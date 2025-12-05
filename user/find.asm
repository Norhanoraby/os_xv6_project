
user/_find:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <print_help>:
#include "kernel/types.h"
#include "kernel/stat.h"
#include "kernel/fs.h"
#include "user/user.h"

void print_help() {
   0:	1141                	addi	sp,sp,-16
   2:	e406                	sd	ra,8(sp)
   4:	e022                	sd	s0,0(sp)
   6:	0800                	addi	s0,sp,16
    printf("Usage: find <directory> <filename>\n");
   8:	00001517          	auipc	a0,0x1
   c:	ad850513          	addi	a0,a0,-1320 # ae0 <malloc+0xfc>
  10:	121000ef          	jal	930 <printf>
}
  14:	60a2                	ld	ra,8(sp)
  16:	6402                	ld	s0,0(sp)
  18:	0141                	addi	sp,sp,16
  1a:	8082                	ret

000000000000001c <same_name>:

// Compare DIRSIZ fixed-length names el bykon 14 bytes lw a2al by add zeros w lw aktar by truncate
int same_name(char *a, char *b) {
  1c:	1141                	addi	sp,sp,-16
  1e:	e422                	sd	s0,8(sp)
  20:	0800                	addi	s0,sp,16
    for (int i = 0; i < DIRSIZ; i++) {
  22:	87aa                	mv	a5,a0
  24:	0539                	addi	a0,a0,14
  26:	a029                	j	30 <same_name+0x14>
  28:	0785                	addi	a5,a5,1
  2a:	0585                	addi	a1,a1,1
  2c:	00a78d63          	beq	a5,a0,46 <same_name+0x2a>
        if (a[i] != b[i])
  30:	0007c703          	lbu	a4,0(a5)
  34:	0005c683          	lbu	a3,0(a1)
  38:	00e69963          	bne	a3,a4,4a <same_name+0x2e>
            return 0;
        if (a[i] == 0 && b[i] == 0)
  3c:	f775                	bnez	a4,28 <same_name+0xc>
            return 1;
  3e:	4505                	li	a0,1
    }
    return 1;
}
  40:	6422                	ld	s0,8(sp)
  42:	0141                	addi	sp,sp,16
  44:	8082                	ret
    return 1;
  46:	4505                	li	a0,1
  48:	bfe5                	j	40 <same_name+0x24>
            return 0;
  4a:	4501                	li	a0,0
  4c:	bfd5                	j	40 <same_name+0x24>

000000000000004e <find>:

// Recursive find function with match count
int find(char *path, char *target) {
  4e:	d8010113          	addi	sp,sp,-640
  52:	26113c23          	sd	ra,632(sp)
  56:	26813823          	sd	s0,624(sp)
  5a:	27213023          	sd	s2,608(sp)
  5e:	25313c23          	sd	s3,600(sp)
  62:	25513423          	sd	s5,584(sp)
  66:	0500                	addi	s0,sp,640
  68:	892a                	mv	s2,a0
  6a:	89ae                	mv	s3,a1
    char buf[512];// bahut feeh full path ex: /home/user/file
    char *p;//pointer for building the path
    int found = 0; // flag to track if we found any match

    // Open directory/file
    fd = open(path, 0);
  6c:	4581                	li	a1,0
  6e:	4ba000ef          	jal	528 <open>
    if (fd < 0) {
  72:	0c054863          	bltz	a0,142 <find+0xf4>
  76:	26913423          	sd	s1,616(sp)
  7a:	84aa                	mv	s1,a0
        printf("find: cannot open %s\n", path);
        return 0;//cannot be opened(not found)
    }
    // if statement de bt2ule lw this path is a file, directory

    if (fstat(fd, &st) < 0) {
  7c:	f9840593          	addi	a1,s0,-104
  80:	4c0000ef          	jal	540 <fstat>
  84:	0c054863          	bltz	a0,154 <find+0x106>
        close(fd);
        return 0;
    }

    // If it's a file, compare filename only
    if (st.type == T_FILE) {
  88:	fa041703          	lh	a4,-96(s0)
  8c:	4789                	li	a5,2
    int found = 0; // flag to track if we found any match
  8e:	4a81                	li	s5,0
    if (st.type == T_FILE) {
  90:	0ef70063          	beq	a4,a5,170 <find+0x122>
  94:	25613023          	sd	s6,576(sp)
  98:	23713c23          	sd	s7,568(sp)
    }

    // Directory case: scan contents
    while (read(fd, &de, sizeof(de)) == sizeof(de)) {
      //skip empty entries Skip . and .. "garbage entries"
        if (de.inum == 0 || strcmp(de.name, ".") == 0 ||strcmp(de.name, "..") == 0)
  9c:	00001b17          	auipc	s6,0x1
  a0:	aa4b0b13          	addi	s6,s6,-1372 # b40 <malloc+0x15c>
  a4:	00001b97          	auipc	s7,0x1
  a8:	aa4b8b93          	addi	s7,s7,-1372 # b48 <malloc+0x164>
    while (read(fd, &de, sizeof(de)) == sizeof(de)) {
  ac:	4641                	li	a2,16
  ae:	f8840593          	addi	a1,s0,-120
  b2:	8526                	mv	a0,s1
  b4:	44c000ef          	jal	500 <read>
  b8:	47c1                	li	a5,16
  ba:	12f51b63          	bne	a0,a5,1f0 <find+0x1a2>
        if (de.inum == 0 || strcmp(de.name, ".") == 0 ||strcmp(de.name, "..") == 0)
  be:	f8845783          	lhu	a5,-120(s0)
  c2:	d7ed                	beqz	a5,ac <find+0x5e>
  c4:	85da                	mv	a1,s6
  c6:	f8a40513          	addi	a0,s0,-118
  ca:	1e2000ef          	jal	2ac <strcmp>
  ce:	dd79                	beqz	a0,ac <find+0x5e>
  d0:	85de                	mv	a1,s7
  d2:	f8a40513          	addi	a0,s0,-118
  d6:	1d6000ef          	jal	2ac <strcmp>
  da:	d969                	beqz	a0,ac <find+0x5e>
  dc:	25413823          	sd	s4,592(sp)
            continue;

        // Build full path: path + "/" + name ex: path=/home ,de.name=a.txt
        strcpy(buf, path); // bahut fl buffer /home
  e0:	85ca                	mv	a1,s2
  e2:	d8840513          	addi	a0,s0,-632
  e6:	1aa000ef          	jal	290 <strcpy>
        p = buf + strlen(buf);// khalet el pointery yb2a 3and end of string el howa "e"
  ea:	d8840513          	addi	a0,s0,-632
  ee:	1ea000ef          	jal	2d8 <strlen>
  f2:	1502                	slli	a0,a0,0x20
  f4:	9101                	srli	a0,a0,0x20
  f6:	d8840793          	addi	a5,s0,-632
  fa:	00a78a33          	add	s4,a5,a0
        *p++ = '/';// add / ba3d /home f hatkon "/home/"
  fe:	02f00793          	li	a5,47
 102:	00fa0023          	sb	a5,0(s4)
        memmove(p, de.name, DIRSIZ);//copy the 14 byte fixed filename
 106:	4639                	li	a2,14
 108:	f8a40593          	addi	a1,s0,-118
 10c:	001a0513          	addi	a0,s4,1
 110:	32a000ef          	jal	43a <memmove>
        p[DIRSIZ] = 0; // null-terminate
 114:	000a07a3          	sb	zero,15(s4)

        if (strcmp(de.name, target) == 0) {//check filename with target
 118:	85ce                	mv	a1,s3
 11a:	f8a40513          	addi	a0,s0,-118
 11e:	18e000ef          	jal	2ac <strcmp>
 122:	cd49                	beqz	a0,1bc <find+0x16e>
            printf("%s\n", buf);//print the full path
            found = 1;
        }

        // If directory → recurse, ex: /home/user/a.txt "ya3ne badawar gowa el home ba3den akhush 3ala user w adawar till i reach file"
        if (stat(buf, &st) == 0 && st.type == T_DIR) {
 124:	f9840593          	addi	a1,s0,-104
 128:	d8840513          	addi	a0,s0,-632
 12c:	28c000ef          	jal	3b8 <stat>
 130:	e955                	bnez	a0,1e4 <find+0x196>
 132:	fa041703          	lh	a4,-96(s0)
 136:	4785                	li	a5,1
 138:	08f70c63          	beq	a4,a5,1d0 <find+0x182>
 13c:	25013a03          	ld	s4,592(sp)
 140:	b7b5                	j	ac <find+0x5e>
        printf("find: cannot open %s\n", path);
 142:	85ca                	mv	a1,s2
 144:	00001517          	auipc	a0,0x1
 148:	9c450513          	addi	a0,a0,-1596 # b08 <malloc+0x124>
 14c:	7e4000ef          	jal	930 <printf>
        return 0;//cannot be opened(not found)
 150:	4a81                	li	s5,0
 152:	a845                	j	202 <find+0x1b4>
        printf("find: cannot stat %s\n", path);
 154:	85ca                	mv	a1,s2
 156:	00001517          	auipc	a0,0x1
 15a:	9ca50513          	addi	a0,a0,-1590 # b20 <malloc+0x13c>
 15e:	7d2000ef          	jal	930 <printf>
        close(fd);
 162:	8526                	mv	a0,s1
 164:	3ac000ef          	jal	510 <close>
        return 0;
 168:	4a81                	li	s5,0
 16a:	26813483          	ld	s1,616(sp)
 16e:	a851                	j	202 <find+0x1b4>
        char *filename = path + strlen(path);
 170:	854a                	mv	a0,s2
 172:	166000ef          	jal	2d8 <strlen>
 176:	1502                	slli	a0,a0,0x20
 178:	9101                	srli	a0,a0,0x20
 17a:	954a                	add	a0,a0,s2
        while (filename > path && *(filename - 1) != '/')//ya3ne hena malesh da3wa bl path ba3ud arga3 lehd mawsal ll file name el howa ba3d akher /
 17c:	02f00713          	li	a4,47
 180:	00a97a63          	bgeu	s2,a0,194 <find+0x146>
 184:	fff54783          	lbu	a5,-1(a0)
 188:	00e78663          	beq	a5,a4,194 <find+0x146>
            filename--;
 18c:	157d                	addi	a0,a0,-1
        while (filename > path && *(filename - 1) != '/')//ya3ne hena malesh da3wa bl path ba3ud arga3 lehd mawsal ll file name el howa ba3d akher /
 18e:	fea91be3          	bne	s2,a0,184 <find+0x136>
 192:	854a                	mv	a0,s2
        if (strcmp(filename, target) == 0) {// compare this file name with the target and if match do this
 194:	85ce                	mv	a1,s3
 196:	116000ef          	jal	2ac <strcmp>
    int found = 0; // flag to track if we found any match
 19a:	4a81                	li	s5,0
        if (strcmp(filename, target) == 0) {// compare this file name with the target and if match do this
 19c:	c519                	beqz	a0,1aa <find+0x15c>
        close(fd);
 19e:	8526                	mv	a0,s1
 1a0:	370000ef          	jal	510 <close>
        return found;
 1a4:	26813483          	ld	s1,616(sp)
 1a8:	a8a9                	j	202 <find+0x1b4>
            printf("%s\n", path);
 1aa:	85ca                	mv	a1,s2
 1ac:	00001517          	auipc	a0,0x1
 1b0:	98c50513          	addi	a0,a0,-1652 # b38 <malloc+0x154>
 1b4:	77c000ef          	jal	930 <printf>
            found = 1;
 1b8:	4a85                	li	s5,1
 1ba:	b7d5                	j	19e <find+0x150>
            printf("%s\n", buf);//print the full path
 1bc:	d8840593          	addi	a1,s0,-632
 1c0:	00001517          	auipc	a0,0x1
 1c4:	97850513          	addi	a0,a0,-1672 # b38 <malloc+0x154>
 1c8:	768000ef          	jal	930 <printf>
            found = 1;
 1cc:	4a85                	li	s5,1
 1ce:	bf99                	j	124 <find+0xd6>
            if (find(buf, target))
 1d0:	85ce                	mv	a1,s3
 1d2:	d8840513          	addi	a0,s0,-632
 1d6:	e79ff0ef          	jal	4e <find>
 1da:	c901                	beqz	a0,1ea <find+0x19c>
                found = 1; // if found in subdir, mark as found
 1dc:	4a85                	li	s5,1
 1de:	25013a03          	ld	s4,592(sp)
 1e2:	b5e9                	j	ac <find+0x5e>
 1e4:	25013a03          	ld	s4,592(sp)
 1e8:	b5d1                	j	ac <find+0x5e>
 1ea:	25013a03          	ld	s4,592(sp)
 1ee:	bd7d                	j	ac <find+0x5e>
        }
    }

    close(fd);
 1f0:	8526                	mv	a0,s1
 1f2:	31e000ef          	jal	510 <close>
 1f6:	26813483          	ld	s1,616(sp)
 1fa:	24013b03          	ld	s6,576(sp)
 1fe:	23813b83          	ld	s7,568(sp)
    return found;
}
 202:	8556                	mv	a0,s5
 204:	27813083          	ld	ra,632(sp)
 208:	27013403          	ld	s0,624(sp)
 20c:	26013903          	ld	s2,608(sp)
 210:	25813983          	ld	s3,600(sp)
 214:	24813a83          	ld	s5,584(sp)
 218:	28010113          	addi	sp,sp,640
 21c:	8082                	ret

000000000000021e <main>:

int main(int argc, char *argv[]) {
 21e:	1101                	addi	sp,sp,-32
 220:	ec06                	sd	ra,24(sp)
 222:	e822                	sd	s0,16(sp)
 224:	e426                	sd	s1,8(sp)
 226:	1000                	addi	s0,sp,32
 228:	84ae                	mv	s1,a1
    if (argc == 2 && strcmp(argv[1], "?") == 0) {
 22a:	4789                	li	a5,2
 22c:	00f50a63          	beq	a0,a5,240 <main+0x22>
        print_help();
        exit(0);
    }

    if (argc != 3) {
 230:	478d                	li	a5,3
 232:	02f50463          	beq	a0,a5,25a <main+0x3c>
        print_help();
 236:	dcbff0ef          	jal	0 <print_help>
        exit(1);
 23a:	4505                	li	a0,1
 23c:	2ac000ef          	jal	4e8 <exit>
    if (argc == 2 && strcmp(argv[1], "?") == 0) {
 240:	00001597          	auipc	a1,0x1
 244:	91058593          	addi	a1,a1,-1776 # b50 <malloc+0x16c>
 248:	6488                	ld	a0,8(s1)
 24a:	062000ef          	jal	2ac <strcmp>
 24e:	f565                	bnez	a0,236 <main+0x18>
        print_help();
 250:	db1ff0ef          	jal	0 <print_help>
        exit(0);
 254:	4501                	li	a0,0
 256:	292000ef          	jal	4e8 <exit>
    }

    // Call find and check if file was found
    if (!find(argv[1], argv[2])) {
 25a:	698c                	ld	a1,16(a1)
 25c:	6488                	ld	a0,8(s1)
 25e:	df1ff0ef          	jal	4e <find>
 262:	e919                	bnez	a0,278 <main+0x5a>
        printf("find: file '%s' not found\n", argv[2]);
 264:	688c                	ld	a1,16(s1)
 266:	00001517          	auipc	a0,0x1
 26a:	8f250513          	addi	a0,a0,-1806 # b58 <malloc+0x174>
 26e:	6c2000ef          	jal	930 <printf>
        exit(1); // error code
 272:	4505                	li	a0,1
 274:	274000ef          	jal	4e8 <exit>
    }

    exit(0);
 278:	4501                	li	a0,0
 27a:	26e000ef          	jal	4e8 <exit>

000000000000027e <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start()
{
 27e:	1141                	addi	sp,sp,-16
 280:	e406                	sd	ra,8(sp)
 282:	e022                	sd	s0,0(sp)
 284:	0800                	addi	s0,sp,16
  extern int main();
  main();
 286:	f99ff0ef          	jal	21e <main>
  exit(0);
 28a:	4501                	li	a0,0
 28c:	25c000ef          	jal	4e8 <exit>

0000000000000290 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
 290:	1141                	addi	sp,sp,-16
 292:	e422                	sd	s0,8(sp)
 294:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 296:	87aa                	mv	a5,a0
 298:	0585                	addi	a1,a1,1
 29a:	0785                	addi	a5,a5,1
 29c:	fff5c703          	lbu	a4,-1(a1)
 2a0:	fee78fa3          	sb	a4,-1(a5)
 2a4:	fb75                	bnez	a4,298 <strcpy+0x8>
    ;
  return os;
}
 2a6:	6422                	ld	s0,8(sp)
 2a8:	0141                	addi	sp,sp,16
 2aa:	8082                	ret

00000000000002ac <strcmp>:

int
strcmp(const char *p, const char *q)
{
 2ac:	1141                	addi	sp,sp,-16
 2ae:	e422                	sd	s0,8(sp)
 2b0:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 2b2:	00054783          	lbu	a5,0(a0)
 2b6:	cb91                	beqz	a5,2ca <strcmp+0x1e>
 2b8:	0005c703          	lbu	a4,0(a1)
 2bc:	00f71763          	bne	a4,a5,2ca <strcmp+0x1e>
    p++, q++;
 2c0:	0505                	addi	a0,a0,1
 2c2:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 2c4:	00054783          	lbu	a5,0(a0)
 2c8:	fbe5                	bnez	a5,2b8 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 2ca:	0005c503          	lbu	a0,0(a1)
}
 2ce:	40a7853b          	subw	a0,a5,a0
 2d2:	6422                	ld	s0,8(sp)
 2d4:	0141                	addi	sp,sp,16
 2d6:	8082                	ret

00000000000002d8 <strlen>:

uint
strlen(const char *s)
{
 2d8:	1141                	addi	sp,sp,-16
 2da:	e422                	sd	s0,8(sp)
 2dc:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 2de:	00054783          	lbu	a5,0(a0)
 2e2:	cf91                	beqz	a5,2fe <strlen+0x26>
 2e4:	0505                	addi	a0,a0,1
 2e6:	87aa                	mv	a5,a0
 2e8:	86be                	mv	a3,a5
 2ea:	0785                	addi	a5,a5,1
 2ec:	fff7c703          	lbu	a4,-1(a5)
 2f0:	ff65                	bnez	a4,2e8 <strlen+0x10>
 2f2:	40a6853b          	subw	a0,a3,a0
 2f6:	2505                	addiw	a0,a0,1
    ;
  return n;
}
 2f8:	6422                	ld	s0,8(sp)
 2fa:	0141                	addi	sp,sp,16
 2fc:	8082                	ret
  for(n = 0; s[n]; n++)
 2fe:	4501                	li	a0,0
 300:	bfe5                	j	2f8 <strlen+0x20>

0000000000000302 <memset>:

void*
memset(void *dst, int c, uint n)
{
 302:	1141                	addi	sp,sp,-16
 304:	e422                	sd	s0,8(sp)
 306:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 308:	ca19                	beqz	a2,31e <memset+0x1c>
 30a:	87aa                	mv	a5,a0
 30c:	1602                	slli	a2,a2,0x20
 30e:	9201                	srli	a2,a2,0x20
 310:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 314:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 318:	0785                	addi	a5,a5,1
 31a:	fee79de3          	bne	a5,a4,314 <memset+0x12>
  }
  return dst;
}
 31e:	6422                	ld	s0,8(sp)
 320:	0141                	addi	sp,sp,16
 322:	8082                	ret

0000000000000324 <strchr>:

char*
strchr(const char *s, char c)
{
 324:	1141                	addi	sp,sp,-16
 326:	e422                	sd	s0,8(sp)
 328:	0800                	addi	s0,sp,16
  for(; *s; s++)
 32a:	00054783          	lbu	a5,0(a0)
 32e:	cb99                	beqz	a5,344 <strchr+0x20>
    if(*s == c)
 330:	00f58763          	beq	a1,a5,33e <strchr+0x1a>
  for(; *s; s++)
 334:	0505                	addi	a0,a0,1
 336:	00054783          	lbu	a5,0(a0)
 33a:	fbfd                	bnez	a5,330 <strchr+0xc>
      return (char*)s;
  return 0;
 33c:	4501                	li	a0,0
}
 33e:	6422                	ld	s0,8(sp)
 340:	0141                	addi	sp,sp,16
 342:	8082                	ret
  return 0;
 344:	4501                	li	a0,0
 346:	bfe5                	j	33e <strchr+0x1a>

0000000000000348 <gets>:

char*
gets(char *buf, int max)
{
 348:	711d                	addi	sp,sp,-96
 34a:	ec86                	sd	ra,88(sp)
 34c:	e8a2                	sd	s0,80(sp)
 34e:	e4a6                	sd	s1,72(sp)
 350:	e0ca                	sd	s2,64(sp)
 352:	fc4e                	sd	s3,56(sp)
 354:	f852                	sd	s4,48(sp)
 356:	f456                	sd	s5,40(sp)
 358:	f05a                	sd	s6,32(sp)
 35a:	ec5e                	sd	s7,24(sp)
 35c:	1080                	addi	s0,sp,96
 35e:	8baa                	mv	s7,a0
 360:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 362:	892a                	mv	s2,a0
 364:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 366:	4aa9                	li	s5,10
 368:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 36a:	89a6                	mv	s3,s1
 36c:	2485                	addiw	s1,s1,1
 36e:	0344d663          	bge	s1,s4,39a <gets+0x52>
    cc = read(0, &c, 1);
 372:	4605                	li	a2,1
 374:	faf40593          	addi	a1,s0,-81
 378:	4501                	li	a0,0
 37a:	186000ef          	jal	500 <read>
    if(cc < 1)
 37e:	00a05e63          	blez	a0,39a <gets+0x52>
    buf[i++] = c;
 382:	faf44783          	lbu	a5,-81(s0)
 386:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 38a:	01578763          	beq	a5,s5,398 <gets+0x50>
 38e:	0905                	addi	s2,s2,1
 390:	fd679de3          	bne	a5,s6,36a <gets+0x22>
    buf[i++] = c;
 394:	89a6                	mv	s3,s1
 396:	a011                	j	39a <gets+0x52>
 398:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 39a:	99de                	add	s3,s3,s7
 39c:	00098023          	sb	zero,0(s3)
  return buf;
}
 3a0:	855e                	mv	a0,s7
 3a2:	60e6                	ld	ra,88(sp)
 3a4:	6446                	ld	s0,80(sp)
 3a6:	64a6                	ld	s1,72(sp)
 3a8:	6906                	ld	s2,64(sp)
 3aa:	79e2                	ld	s3,56(sp)
 3ac:	7a42                	ld	s4,48(sp)
 3ae:	7aa2                	ld	s5,40(sp)
 3b0:	7b02                	ld	s6,32(sp)
 3b2:	6be2                	ld	s7,24(sp)
 3b4:	6125                	addi	sp,sp,96
 3b6:	8082                	ret

00000000000003b8 <stat>:

int
stat(const char *n, struct stat *st)
{
 3b8:	1101                	addi	sp,sp,-32
 3ba:	ec06                	sd	ra,24(sp)
 3bc:	e822                	sd	s0,16(sp)
 3be:	e04a                	sd	s2,0(sp)
 3c0:	1000                	addi	s0,sp,32
 3c2:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 3c4:	4581                	li	a1,0
 3c6:	162000ef          	jal	528 <open>
  if(fd < 0)
 3ca:	02054263          	bltz	a0,3ee <stat+0x36>
 3ce:	e426                	sd	s1,8(sp)
 3d0:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 3d2:	85ca                	mv	a1,s2
 3d4:	16c000ef          	jal	540 <fstat>
 3d8:	892a                	mv	s2,a0
  close(fd);
 3da:	8526                	mv	a0,s1
 3dc:	134000ef          	jal	510 <close>
  return r;
 3e0:	64a2                	ld	s1,8(sp)
}
 3e2:	854a                	mv	a0,s2
 3e4:	60e2                	ld	ra,24(sp)
 3e6:	6442                	ld	s0,16(sp)
 3e8:	6902                	ld	s2,0(sp)
 3ea:	6105                	addi	sp,sp,32
 3ec:	8082                	ret
    return -1;
 3ee:	597d                	li	s2,-1
 3f0:	bfcd                	j	3e2 <stat+0x2a>

00000000000003f2 <atoi>:

int
atoi(const char *s)
{
 3f2:	1141                	addi	sp,sp,-16
 3f4:	e422                	sd	s0,8(sp)
 3f6:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 3f8:	00054683          	lbu	a3,0(a0)
 3fc:	fd06879b          	addiw	a5,a3,-48
 400:	0ff7f793          	zext.b	a5,a5
 404:	4625                	li	a2,9
 406:	02f66863          	bltu	a2,a5,436 <atoi+0x44>
 40a:	872a                	mv	a4,a0
  n = 0;
 40c:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 40e:	0705                	addi	a4,a4,1
 410:	0025179b          	slliw	a5,a0,0x2
 414:	9fa9                	addw	a5,a5,a0
 416:	0017979b          	slliw	a5,a5,0x1
 41a:	9fb5                	addw	a5,a5,a3
 41c:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 420:	00074683          	lbu	a3,0(a4)
 424:	fd06879b          	addiw	a5,a3,-48
 428:	0ff7f793          	zext.b	a5,a5
 42c:	fef671e3          	bgeu	a2,a5,40e <atoi+0x1c>
  return n;
}
 430:	6422                	ld	s0,8(sp)
 432:	0141                	addi	sp,sp,16
 434:	8082                	ret
  n = 0;
 436:	4501                	li	a0,0
 438:	bfe5                	j	430 <atoi+0x3e>

000000000000043a <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 43a:	1141                	addi	sp,sp,-16
 43c:	e422                	sd	s0,8(sp)
 43e:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 440:	02b57463          	bgeu	a0,a1,468 <memmove+0x2e>
    while(n-- > 0)
 444:	00c05f63          	blez	a2,462 <memmove+0x28>
 448:	1602                	slli	a2,a2,0x20
 44a:	9201                	srli	a2,a2,0x20
 44c:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 450:	872a                	mv	a4,a0
      *dst++ = *src++;
 452:	0585                	addi	a1,a1,1
 454:	0705                	addi	a4,a4,1
 456:	fff5c683          	lbu	a3,-1(a1)
 45a:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 45e:	fef71ae3          	bne	a4,a5,452 <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 462:	6422                	ld	s0,8(sp)
 464:	0141                	addi	sp,sp,16
 466:	8082                	ret
    dst += n;
 468:	00c50733          	add	a4,a0,a2
    src += n;
 46c:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 46e:	fec05ae3          	blez	a2,462 <memmove+0x28>
 472:	fff6079b          	addiw	a5,a2,-1
 476:	1782                	slli	a5,a5,0x20
 478:	9381                	srli	a5,a5,0x20
 47a:	fff7c793          	not	a5,a5
 47e:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 480:	15fd                	addi	a1,a1,-1
 482:	177d                	addi	a4,a4,-1
 484:	0005c683          	lbu	a3,0(a1)
 488:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 48c:	fee79ae3          	bne	a5,a4,480 <memmove+0x46>
 490:	bfc9                	j	462 <memmove+0x28>

0000000000000492 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 492:	1141                	addi	sp,sp,-16
 494:	e422                	sd	s0,8(sp)
 496:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 498:	ca05                	beqz	a2,4c8 <memcmp+0x36>
 49a:	fff6069b          	addiw	a3,a2,-1
 49e:	1682                	slli	a3,a3,0x20
 4a0:	9281                	srli	a3,a3,0x20
 4a2:	0685                	addi	a3,a3,1
 4a4:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 4a6:	00054783          	lbu	a5,0(a0)
 4aa:	0005c703          	lbu	a4,0(a1)
 4ae:	00e79863          	bne	a5,a4,4be <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 4b2:	0505                	addi	a0,a0,1
    p2++;
 4b4:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 4b6:	fed518e3          	bne	a0,a3,4a6 <memcmp+0x14>
  }
  return 0;
 4ba:	4501                	li	a0,0
 4bc:	a019                	j	4c2 <memcmp+0x30>
      return *p1 - *p2;
 4be:	40e7853b          	subw	a0,a5,a4
}
 4c2:	6422                	ld	s0,8(sp)
 4c4:	0141                	addi	sp,sp,16
 4c6:	8082                	ret
  return 0;
 4c8:	4501                	li	a0,0
 4ca:	bfe5                	j	4c2 <memcmp+0x30>

00000000000004cc <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 4cc:	1141                	addi	sp,sp,-16
 4ce:	e406                	sd	ra,8(sp)
 4d0:	e022                	sd	s0,0(sp)
 4d2:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 4d4:	f67ff0ef          	jal	43a <memmove>
}
 4d8:	60a2                	ld	ra,8(sp)
 4da:	6402                	ld	s0,0(sp)
 4dc:	0141                	addi	sp,sp,16
 4de:	8082                	ret

00000000000004e0 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 4e0:	4885                	li	a7,1
 ecall
 4e2:	00000073          	ecall
 ret
 4e6:	8082                	ret

00000000000004e8 <exit>:
.global exit
exit:
 li a7, SYS_exit
 4e8:	4889                	li	a7,2
 ecall
 4ea:	00000073          	ecall
 ret
 4ee:	8082                	ret

00000000000004f0 <wait>:
.global wait
wait:
 li a7, SYS_wait
 4f0:	488d                	li	a7,3
 ecall
 4f2:	00000073          	ecall
 ret
 4f6:	8082                	ret

00000000000004f8 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 4f8:	4891                	li	a7,4
 ecall
 4fa:	00000073          	ecall
 ret
 4fe:	8082                	ret

0000000000000500 <read>:
.global read
read:
 li a7, SYS_read
 500:	4895                	li	a7,5
 ecall
 502:	00000073          	ecall
 ret
 506:	8082                	ret

0000000000000508 <write>:
.global write
write:
 li a7, SYS_write
 508:	48c1                	li	a7,16
 ecall
 50a:	00000073          	ecall
 ret
 50e:	8082                	ret

0000000000000510 <close>:
.global close
close:
 li a7, SYS_close
 510:	48d5                	li	a7,21
 ecall
 512:	00000073          	ecall
 ret
 516:	8082                	ret

0000000000000518 <kill>:
.global kill
kill:
 li a7, SYS_kill
 518:	4899                	li	a7,6
 ecall
 51a:	00000073          	ecall
 ret
 51e:	8082                	ret

0000000000000520 <exec>:
.global exec
exec:
 li a7, SYS_exec
 520:	489d                	li	a7,7
 ecall
 522:	00000073          	ecall
 ret
 526:	8082                	ret

0000000000000528 <open>:
.global open
open:
 li a7, SYS_open
 528:	48bd                	li	a7,15
 ecall
 52a:	00000073          	ecall
 ret
 52e:	8082                	ret

0000000000000530 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 530:	48c5                	li	a7,17
 ecall
 532:	00000073          	ecall
 ret
 536:	8082                	ret

0000000000000538 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 538:	48c9                	li	a7,18
 ecall
 53a:	00000073          	ecall
 ret
 53e:	8082                	ret

0000000000000540 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 540:	48a1                	li	a7,8
 ecall
 542:	00000073          	ecall
 ret
 546:	8082                	ret

0000000000000548 <link>:
.global link
link:
 li a7, SYS_link
 548:	48cd                	li	a7,19
 ecall
 54a:	00000073          	ecall
 ret
 54e:	8082                	ret

0000000000000550 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 550:	48d1                	li	a7,20
 ecall
 552:	00000073          	ecall
 ret
 556:	8082                	ret

0000000000000558 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 558:	48a5                	li	a7,9
 ecall
 55a:	00000073          	ecall
 ret
 55e:	8082                	ret

0000000000000560 <dup>:
.global dup
dup:
 li a7, SYS_dup
 560:	48a9                	li	a7,10
 ecall
 562:	00000073          	ecall
 ret
 566:	8082                	ret

0000000000000568 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 568:	48ad                	li	a7,11
 ecall
 56a:	00000073          	ecall
 ret
 56e:	8082                	ret

0000000000000570 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 570:	48b1                	li	a7,12
 ecall
 572:	00000073          	ecall
 ret
 576:	8082                	ret

0000000000000578 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 578:	48b5                	li	a7,13
 ecall
 57a:	00000073          	ecall
 ret
 57e:	8082                	ret

0000000000000580 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 580:	48b9                	li	a7,14
 ecall
 582:	00000073          	ecall
 ret
 586:	8082                	ret

0000000000000588 <kbdint>:
.global kbdint
kbdint:
 li a7, SYS_kbdint
 588:	48d9                	li	a7,22
 ecall
 58a:	00000073          	ecall
 ret
 58e:	8082                	ret

0000000000000590 <countsyscall>:
.global countsyscall
countsyscall:
 li a7, SYS_countsyscall
 590:	48dd                	li	a7,23
 ecall
 592:	00000073          	ecall
 ret
 596:	8082                	ret

0000000000000598 <getppid>:
.global getppid
getppid:
 li a7, SYS_getppid
 598:	48e1                	li	a7,24
 ecall
 59a:	00000073          	ecall
 ret
 59e:	8082                	ret

00000000000005a0 <shutdown>:
.global shutdown
shutdown:
 li a7, SYS_shutdown
 5a0:	48e5                	li	a7,25
 ecall
 5a2:	00000073          	ecall
 ret
 5a6:	8082                	ret

00000000000005a8 <random>:
.global random
random:
 li a7, SYS_random
 5a8:	48e9                	li	a7,26
 ecall
 5aa:	00000073          	ecall
 ret
 5ae:	8082                	ret

00000000000005b0 <datetime>:
.global datetime
datetime:
 li a7, SYS_datetime
 5b0:	48ed                	li	a7,27
 ecall
 5b2:	00000073          	ecall
 ret
 5b6:	8082                	ret

00000000000005b8 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 5b8:	1101                	addi	sp,sp,-32
 5ba:	ec06                	sd	ra,24(sp)
 5bc:	e822                	sd	s0,16(sp)
 5be:	1000                	addi	s0,sp,32
 5c0:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 5c4:	4605                	li	a2,1
 5c6:	fef40593          	addi	a1,s0,-17
 5ca:	f3fff0ef          	jal	508 <write>
}
 5ce:	60e2                	ld	ra,24(sp)
 5d0:	6442                	ld	s0,16(sp)
 5d2:	6105                	addi	sp,sp,32
 5d4:	8082                	ret

00000000000005d6 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 5d6:	7139                	addi	sp,sp,-64
 5d8:	fc06                	sd	ra,56(sp)
 5da:	f822                	sd	s0,48(sp)
 5dc:	f426                	sd	s1,40(sp)
 5de:	0080                	addi	s0,sp,64
 5e0:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 5e2:	c299                	beqz	a3,5e8 <printint+0x12>
 5e4:	0805c963          	bltz	a1,676 <printint+0xa0>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 5e8:	2581                	sext.w	a1,a1
  neg = 0;
 5ea:	4881                	li	a7,0
 5ec:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 5f0:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 5f2:	2601                	sext.w	a2,a2
 5f4:	00000517          	auipc	a0,0x0
 5f8:	58c50513          	addi	a0,a0,1420 # b80 <digits>
 5fc:	883a                	mv	a6,a4
 5fe:	2705                	addiw	a4,a4,1
 600:	02c5f7bb          	remuw	a5,a1,a2
 604:	1782                	slli	a5,a5,0x20
 606:	9381                	srli	a5,a5,0x20
 608:	97aa                	add	a5,a5,a0
 60a:	0007c783          	lbu	a5,0(a5)
 60e:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 612:	0005879b          	sext.w	a5,a1
 616:	02c5d5bb          	divuw	a1,a1,a2
 61a:	0685                	addi	a3,a3,1
 61c:	fec7f0e3          	bgeu	a5,a2,5fc <printint+0x26>
  if(neg)
 620:	00088c63          	beqz	a7,638 <printint+0x62>
    buf[i++] = '-';
 624:	fd070793          	addi	a5,a4,-48
 628:	00878733          	add	a4,a5,s0
 62c:	02d00793          	li	a5,45
 630:	fef70823          	sb	a5,-16(a4)
 634:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 638:	02e05a63          	blez	a4,66c <printint+0x96>
 63c:	f04a                	sd	s2,32(sp)
 63e:	ec4e                	sd	s3,24(sp)
 640:	fc040793          	addi	a5,s0,-64
 644:	00e78933          	add	s2,a5,a4
 648:	fff78993          	addi	s3,a5,-1
 64c:	99ba                	add	s3,s3,a4
 64e:	377d                	addiw	a4,a4,-1
 650:	1702                	slli	a4,a4,0x20
 652:	9301                	srli	a4,a4,0x20
 654:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 658:	fff94583          	lbu	a1,-1(s2)
 65c:	8526                	mv	a0,s1
 65e:	f5bff0ef          	jal	5b8 <putc>
  while(--i >= 0)
 662:	197d                	addi	s2,s2,-1
 664:	ff391ae3          	bne	s2,s3,658 <printint+0x82>
 668:	7902                	ld	s2,32(sp)
 66a:	69e2                	ld	s3,24(sp)
}
 66c:	70e2                	ld	ra,56(sp)
 66e:	7442                	ld	s0,48(sp)
 670:	74a2                	ld	s1,40(sp)
 672:	6121                	addi	sp,sp,64
 674:	8082                	ret
    x = -xx;
 676:	40b005bb          	negw	a1,a1
    neg = 1;
 67a:	4885                	li	a7,1
    x = -xx;
 67c:	bf85                	j	5ec <printint+0x16>

000000000000067e <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 67e:	711d                	addi	sp,sp,-96
 680:	ec86                	sd	ra,88(sp)
 682:	e8a2                	sd	s0,80(sp)
 684:	e0ca                	sd	s2,64(sp)
 686:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 688:	0005c903          	lbu	s2,0(a1)
 68c:	26090863          	beqz	s2,8fc <vprintf+0x27e>
 690:	e4a6                	sd	s1,72(sp)
 692:	fc4e                	sd	s3,56(sp)
 694:	f852                	sd	s4,48(sp)
 696:	f456                	sd	s5,40(sp)
 698:	f05a                	sd	s6,32(sp)
 69a:	ec5e                	sd	s7,24(sp)
 69c:	e862                	sd	s8,16(sp)
 69e:	e466                	sd	s9,8(sp)
 6a0:	8b2a                	mv	s6,a0
 6a2:	8a2e                	mv	s4,a1
 6a4:	8bb2                	mv	s7,a2
  state = 0;
 6a6:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 6a8:	4481                	li	s1,0
 6aa:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 6ac:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 6b0:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 6b4:	06c00c93          	li	s9,108
 6b8:	a005                	j	6d8 <vprintf+0x5a>
        putc(fd, c0);
 6ba:	85ca                	mv	a1,s2
 6bc:	855a                	mv	a0,s6
 6be:	efbff0ef          	jal	5b8 <putc>
 6c2:	a019                	j	6c8 <vprintf+0x4a>
    } else if(state == '%'){
 6c4:	03598263          	beq	s3,s5,6e8 <vprintf+0x6a>
  for(i = 0; fmt[i]; i++){
 6c8:	2485                	addiw	s1,s1,1
 6ca:	8726                	mv	a4,s1
 6cc:	009a07b3          	add	a5,s4,s1
 6d0:	0007c903          	lbu	s2,0(a5)
 6d4:	20090c63          	beqz	s2,8ec <vprintf+0x26e>
    c0 = fmt[i] & 0xff;
 6d8:	0009079b          	sext.w	a5,s2
    if(state == 0){
 6dc:	fe0994e3          	bnez	s3,6c4 <vprintf+0x46>
      if(c0 == '%'){
 6e0:	fd579de3          	bne	a5,s5,6ba <vprintf+0x3c>
        state = '%';
 6e4:	89be                	mv	s3,a5
 6e6:	b7cd                	j	6c8 <vprintf+0x4a>
      if(c0) c1 = fmt[i+1] & 0xff;
 6e8:	00ea06b3          	add	a3,s4,a4
 6ec:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 6f0:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
 6f2:	c681                	beqz	a3,6fa <vprintf+0x7c>
 6f4:	9752                	add	a4,a4,s4
 6f6:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
 6fa:	03878f63          	beq	a5,s8,738 <vprintf+0xba>
      } else if(c0 == 'l' && c1 == 'd'){
 6fe:	05978963          	beq	a5,s9,750 <vprintf+0xd2>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
 702:	07500713          	li	a4,117
 706:	0ee78363          	beq	a5,a4,7ec <vprintf+0x16e>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
 70a:	07800713          	li	a4,120
 70e:	12e78563          	beq	a5,a4,838 <vprintf+0x1ba>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
 712:	07000713          	li	a4,112
 716:	14e78a63          	beq	a5,a4,86a <vprintf+0x1ec>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 's'){
 71a:	07300713          	li	a4,115
 71e:	18e78a63          	beq	a5,a4,8b2 <vprintf+0x234>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
 722:	02500713          	li	a4,37
 726:	04e79563          	bne	a5,a4,770 <vprintf+0xf2>
        putc(fd, '%');
 72a:	02500593          	li	a1,37
 72e:	855a                	mv	a0,s6
 730:	e89ff0ef          	jal	5b8 <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
#endif
      state = 0;
 734:	4981                	li	s3,0
 736:	bf49                	j	6c8 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 1);
 738:	008b8913          	addi	s2,s7,8
 73c:	4685                	li	a3,1
 73e:	4629                	li	a2,10
 740:	000ba583          	lw	a1,0(s7)
 744:	855a                	mv	a0,s6
 746:	e91ff0ef          	jal	5d6 <printint>
 74a:	8bca                	mv	s7,s2
      state = 0;
 74c:	4981                	li	s3,0
 74e:	bfad                	j	6c8 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'd'){
 750:	06400793          	li	a5,100
 754:	02f68963          	beq	a3,a5,786 <vprintf+0x108>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 758:	06c00793          	li	a5,108
 75c:	04f68263          	beq	a3,a5,7a0 <vprintf+0x122>
      } else if(c0 == 'l' && c1 == 'u'){
 760:	07500793          	li	a5,117
 764:	0af68063          	beq	a3,a5,804 <vprintf+0x186>
      } else if(c0 == 'l' && c1 == 'x'){
 768:	07800793          	li	a5,120
 76c:	0ef68263          	beq	a3,a5,850 <vprintf+0x1d2>
        putc(fd, '%');
 770:	02500593          	li	a1,37
 774:	855a                	mv	a0,s6
 776:	e43ff0ef          	jal	5b8 <putc>
        putc(fd, c0);
 77a:	85ca                	mv	a1,s2
 77c:	855a                	mv	a0,s6
 77e:	e3bff0ef          	jal	5b8 <putc>
      state = 0;
 782:	4981                	li	s3,0
 784:	b791                	j	6c8 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 786:	008b8913          	addi	s2,s7,8
 78a:	4685                	li	a3,1
 78c:	4629                	li	a2,10
 78e:	000ba583          	lw	a1,0(s7)
 792:	855a                	mv	a0,s6
 794:	e43ff0ef          	jal	5d6 <printint>
        i += 1;
 798:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 79a:	8bca                	mv	s7,s2
      state = 0;
 79c:	4981                	li	s3,0
        i += 1;
 79e:	b72d                	j	6c8 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 7a0:	06400793          	li	a5,100
 7a4:	02f60763          	beq	a2,a5,7d2 <vprintf+0x154>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 7a8:	07500793          	li	a5,117
 7ac:	06f60963          	beq	a2,a5,81e <vprintf+0x1a0>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 7b0:	07800793          	li	a5,120
 7b4:	faf61ee3          	bne	a2,a5,770 <vprintf+0xf2>
        printint(fd, va_arg(ap, uint64), 16, 0);
 7b8:	008b8913          	addi	s2,s7,8
 7bc:	4681                	li	a3,0
 7be:	4641                	li	a2,16
 7c0:	000ba583          	lw	a1,0(s7)
 7c4:	855a                	mv	a0,s6
 7c6:	e11ff0ef          	jal	5d6 <printint>
        i += 2;
 7ca:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 7cc:	8bca                	mv	s7,s2
      state = 0;
 7ce:	4981                	li	s3,0
        i += 2;
 7d0:	bde5                	j	6c8 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 7d2:	008b8913          	addi	s2,s7,8
 7d6:	4685                	li	a3,1
 7d8:	4629                	li	a2,10
 7da:	000ba583          	lw	a1,0(s7)
 7de:	855a                	mv	a0,s6
 7e0:	df7ff0ef          	jal	5d6 <printint>
        i += 2;
 7e4:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 7e6:	8bca                	mv	s7,s2
      state = 0;
 7e8:	4981                	li	s3,0
        i += 2;
 7ea:	bdf9                	j	6c8 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 0);
 7ec:	008b8913          	addi	s2,s7,8
 7f0:	4681                	li	a3,0
 7f2:	4629                	li	a2,10
 7f4:	000ba583          	lw	a1,0(s7)
 7f8:	855a                	mv	a0,s6
 7fa:	dddff0ef          	jal	5d6 <printint>
 7fe:	8bca                	mv	s7,s2
      state = 0;
 800:	4981                	li	s3,0
 802:	b5d9                	j	6c8 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 804:	008b8913          	addi	s2,s7,8
 808:	4681                	li	a3,0
 80a:	4629                	li	a2,10
 80c:	000ba583          	lw	a1,0(s7)
 810:	855a                	mv	a0,s6
 812:	dc5ff0ef          	jal	5d6 <printint>
        i += 1;
 816:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 818:	8bca                	mv	s7,s2
      state = 0;
 81a:	4981                	li	s3,0
        i += 1;
 81c:	b575                	j	6c8 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 81e:	008b8913          	addi	s2,s7,8
 822:	4681                	li	a3,0
 824:	4629                	li	a2,10
 826:	000ba583          	lw	a1,0(s7)
 82a:	855a                	mv	a0,s6
 82c:	dabff0ef          	jal	5d6 <printint>
        i += 2;
 830:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 832:	8bca                	mv	s7,s2
      state = 0;
 834:	4981                	li	s3,0
        i += 2;
 836:	bd49                	j	6c8 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 16, 0);
 838:	008b8913          	addi	s2,s7,8
 83c:	4681                	li	a3,0
 83e:	4641                	li	a2,16
 840:	000ba583          	lw	a1,0(s7)
 844:	855a                	mv	a0,s6
 846:	d91ff0ef          	jal	5d6 <printint>
 84a:	8bca                	mv	s7,s2
      state = 0;
 84c:	4981                	li	s3,0
 84e:	bdad                	j	6c8 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 16, 0);
 850:	008b8913          	addi	s2,s7,8
 854:	4681                	li	a3,0
 856:	4641                	li	a2,16
 858:	000ba583          	lw	a1,0(s7)
 85c:	855a                	mv	a0,s6
 85e:	d79ff0ef          	jal	5d6 <printint>
        i += 1;
 862:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 864:	8bca                	mv	s7,s2
      state = 0;
 866:	4981                	li	s3,0
        i += 1;
 868:	b585                	j	6c8 <vprintf+0x4a>
 86a:	e06a                	sd	s10,0(sp)
        printptr(fd, va_arg(ap, uint64));
 86c:	008b8d13          	addi	s10,s7,8
 870:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 874:	03000593          	li	a1,48
 878:	855a                	mv	a0,s6
 87a:	d3fff0ef          	jal	5b8 <putc>
  putc(fd, 'x');
 87e:	07800593          	li	a1,120
 882:	855a                	mv	a0,s6
 884:	d35ff0ef          	jal	5b8 <putc>
 888:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 88a:	00000b97          	auipc	s7,0x0
 88e:	2f6b8b93          	addi	s7,s7,758 # b80 <digits>
 892:	03c9d793          	srli	a5,s3,0x3c
 896:	97de                	add	a5,a5,s7
 898:	0007c583          	lbu	a1,0(a5)
 89c:	855a                	mv	a0,s6
 89e:	d1bff0ef          	jal	5b8 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 8a2:	0992                	slli	s3,s3,0x4
 8a4:	397d                	addiw	s2,s2,-1
 8a6:	fe0916e3          	bnez	s2,892 <vprintf+0x214>
        printptr(fd, va_arg(ap, uint64));
 8aa:	8bea                	mv	s7,s10
      state = 0;
 8ac:	4981                	li	s3,0
 8ae:	6d02                	ld	s10,0(sp)
 8b0:	bd21                	j	6c8 <vprintf+0x4a>
        if((s = va_arg(ap, char*)) == 0)
 8b2:	008b8993          	addi	s3,s7,8
 8b6:	000bb903          	ld	s2,0(s7)
 8ba:	00090f63          	beqz	s2,8d8 <vprintf+0x25a>
        for(; *s; s++)
 8be:	00094583          	lbu	a1,0(s2)
 8c2:	c195                	beqz	a1,8e6 <vprintf+0x268>
          putc(fd, *s);
 8c4:	855a                	mv	a0,s6
 8c6:	cf3ff0ef          	jal	5b8 <putc>
        for(; *s; s++)
 8ca:	0905                	addi	s2,s2,1
 8cc:	00094583          	lbu	a1,0(s2)
 8d0:	f9f5                	bnez	a1,8c4 <vprintf+0x246>
        if((s = va_arg(ap, char*)) == 0)
 8d2:	8bce                	mv	s7,s3
      state = 0;
 8d4:	4981                	li	s3,0
 8d6:	bbcd                	j	6c8 <vprintf+0x4a>
          s = "(null)";
 8d8:	00000917          	auipc	s2,0x0
 8dc:	2a090913          	addi	s2,s2,672 # b78 <malloc+0x194>
        for(; *s; s++)
 8e0:	02800593          	li	a1,40
 8e4:	b7c5                	j	8c4 <vprintf+0x246>
        if((s = va_arg(ap, char*)) == 0)
 8e6:	8bce                	mv	s7,s3
      state = 0;
 8e8:	4981                	li	s3,0
 8ea:	bbf9                	j	6c8 <vprintf+0x4a>
 8ec:	64a6                	ld	s1,72(sp)
 8ee:	79e2                	ld	s3,56(sp)
 8f0:	7a42                	ld	s4,48(sp)
 8f2:	7aa2                	ld	s5,40(sp)
 8f4:	7b02                	ld	s6,32(sp)
 8f6:	6be2                	ld	s7,24(sp)
 8f8:	6c42                	ld	s8,16(sp)
 8fa:	6ca2                	ld	s9,8(sp)
    }
  }
}
 8fc:	60e6                	ld	ra,88(sp)
 8fe:	6446                	ld	s0,80(sp)
 900:	6906                	ld	s2,64(sp)
 902:	6125                	addi	sp,sp,96
 904:	8082                	ret

0000000000000906 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 906:	715d                	addi	sp,sp,-80
 908:	ec06                	sd	ra,24(sp)
 90a:	e822                	sd	s0,16(sp)
 90c:	1000                	addi	s0,sp,32
 90e:	e010                	sd	a2,0(s0)
 910:	e414                	sd	a3,8(s0)
 912:	e818                	sd	a4,16(s0)
 914:	ec1c                	sd	a5,24(s0)
 916:	03043023          	sd	a6,32(s0)
 91a:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 91e:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 922:	8622                	mv	a2,s0
 924:	d5bff0ef          	jal	67e <vprintf>
}
 928:	60e2                	ld	ra,24(sp)
 92a:	6442                	ld	s0,16(sp)
 92c:	6161                	addi	sp,sp,80
 92e:	8082                	ret

0000000000000930 <printf>:

void
printf(const char *fmt, ...)
{
 930:	711d                	addi	sp,sp,-96
 932:	ec06                	sd	ra,24(sp)
 934:	e822                	sd	s0,16(sp)
 936:	1000                	addi	s0,sp,32
 938:	e40c                	sd	a1,8(s0)
 93a:	e810                	sd	a2,16(s0)
 93c:	ec14                	sd	a3,24(s0)
 93e:	f018                	sd	a4,32(s0)
 940:	f41c                	sd	a5,40(s0)
 942:	03043823          	sd	a6,48(s0)
 946:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 94a:	00840613          	addi	a2,s0,8
 94e:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 952:	85aa                	mv	a1,a0
 954:	4505                	li	a0,1
 956:	d29ff0ef          	jal	67e <vprintf>
}
 95a:	60e2                	ld	ra,24(sp)
 95c:	6442                	ld	s0,16(sp)
 95e:	6125                	addi	sp,sp,96
 960:	8082                	ret

0000000000000962 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 962:	1141                	addi	sp,sp,-16
 964:	e422                	sd	s0,8(sp)
 966:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 968:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 96c:	00001797          	auipc	a5,0x1
 970:	6947b783          	ld	a5,1684(a5) # 2000 <freep>
 974:	a02d                	j	99e <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 976:	4618                	lw	a4,8(a2)
 978:	9f2d                	addw	a4,a4,a1
 97a:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 97e:	6398                	ld	a4,0(a5)
 980:	6310                	ld	a2,0(a4)
 982:	a83d                	j	9c0 <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 984:	ff852703          	lw	a4,-8(a0)
 988:	9f31                	addw	a4,a4,a2
 98a:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 98c:	ff053683          	ld	a3,-16(a0)
 990:	a091                	j	9d4 <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 992:	6398                	ld	a4,0(a5)
 994:	00e7e463          	bltu	a5,a4,99c <free+0x3a>
 998:	00e6ea63          	bltu	a3,a4,9ac <free+0x4a>
{
 99c:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 99e:	fed7fae3          	bgeu	a5,a3,992 <free+0x30>
 9a2:	6398                	ld	a4,0(a5)
 9a4:	00e6e463          	bltu	a3,a4,9ac <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 9a8:	fee7eae3          	bltu	a5,a4,99c <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 9ac:	ff852583          	lw	a1,-8(a0)
 9b0:	6390                	ld	a2,0(a5)
 9b2:	02059813          	slli	a6,a1,0x20
 9b6:	01c85713          	srli	a4,a6,0x1c
 9ba:	9736                	add	a4,a4,a3
 9bc:	fae60de3          	beq	a2,a4,976 <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 9c0:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 9c4:	4790                	lw	a2,8(a5)
 9c6:	02061593          	slli	a1,a2,0x20
 9ca:	01c5d713          	srli	a4,a1,0x1c
 9ce:	973e                	add	a4,a4,a5
 9d0:	fae68ae3          	beq	a3,a4,984 <free+0x22>
    p->s.ptr = bp->s.ptr;
 9d4:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 9d6:	00001717          	auipc	a4,0x1
 9da:	62f73523          	sd	a5,1578(a4) # 2000 <freep>
}
 9de:	6422                	ld	s0,8(sp)
 9e0:	0141                	addi	sp,sp,16
 9e2:	8082                	ret

00000000000009e4 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 9e4:	7139                	addi	sp,sp,-64
 9e6:	fc06                	sd	ra,56(sp)
 9e8:	f822                	sd	s0,48(sp)
 9ea:	f426                	sd	s1,40(sp)
 9ec:	ec4e                	sd	s3,24(sp)
 9ee:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 9f0:	02051493          	slli	s1,a0,0x20
 9f4:	9081                	srli	s1,s1,0x20
 9f6:	04bd                	addi	s1,s1,15
 9f8:	8091                	srli	s1,s1,0x4
 9fa:	0014899b          	addiw	s3,s1,1
 9fe:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 a00:	00001517          	auipc	a0,0x1
 a04:	60053503          	ld	a0,1536(a0) # 2000 <freep>
 a08:	c915                	beqz	a0,a3c <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 a0a:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 a0c:	4798                	lw	a4,8(a5)
 a0e:	08977a63          	bgeu	a4,s1,aa2 <malloc+0xbe>
 a12:	f04a                	sd	s2,32(sp)
 a14:	e852                	sd	s4,16(sp)
 a16:	e456                	sd	s5,8(sp)
 a18:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 a1a:	8a4e                	mv	s4,s3
 a1c:	0009871b          	sext.w	a4,s3
 a20:	6685                	lui	a3,0x1
 a22:	00d77363          	bgeu	a4,a3,a28 <malloc+0x44>
 a26:	6a05                	lui	s4,0x1
 a28:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 a2c:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 a30:	00001917          	auipc	s2,0x1
 a34:	5d090913          	addi	s2,s2,1488 # 2000 <freep>
  if(p == (char*)-1)
 a38:	5afd                	li	s5,-1
 a3a:	a081                	j	a7a <malloc+0x96>
 a3c:	f04a                	sd	s2,32(sp)
 a3e:	e852                	sd	s4,16(sp)
 a40:	e456                	sd	s5,8(sp)
 a42:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 a44:	00001797          	auipc	a5,0x1
 a48:	5cc78793          	addi	a5,a5,1484 # 2010 <base>
 a4c:	00001717          	auipc	a4,0x1
 a50:	5af73a23          	sd	a5,1460(a4) # 2000 <freep>
 a54:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 a56:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 a5a:	b7c1                	j	a1a <malloc+0x36>
        prevp->s.ptr = p->s.ptr;
 a5c:	6398                	ld	a4,0(a5)
 a5e:	e118                	sd	a4,0(a0)
 a60:	a8a9                	j	aba <malloc+0xd6>
  hp->s.size = nu;
 a62:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 a66:	0541                	addi	a0,a0,16
 a68:	efbff0ef          	jal	962 <free>
  return freep;
 a6c:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 a70:	c12d                	beqz	a0,ad2 <malloc+0xee>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 a72:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 a74:	4798                	lw	a4,8(a5)
 a76:	02977263          	bgeu	a4,s1,a9a <malloc+0xb6>
    if(p == freep)
 a7a:	00093703          	ld	a4,0(s2)
 a7e:	853e                	mv	a0,a5
 a80:	fef719e3          	bne	a4,a5,a72 <malloc+0x8e>
  p = sbrk(nu * sizeof(Header));
 a84:	8552                	mv	a0,s4
 a86:	aebff0ef          	jal	570 <sbrk>
  if(p == (char*)-1)
 a8a:	fd551ce3          	bne	a0,s5,a62 <malloc+0x7e>
        return 0;
 a8e:	4501                	li	a0,0
 a90:	7902                	ld	s2,32(sp)
 a92:	6a42                	ld	s4,16(sp)
 a94:	6aa2                	ld	s5,8(sp)
 a96:	6b02                	ld	s6,0(sp)
 a98:	a03d                	j	ac6 <malloc+0xe2>
 a9a:	7902                	ld	s2,32(sp)
 a9c:	6a42                	ld	s4,16(sp)
 a9e:	6aa2                	ld	s5,8(sp)
 aa0:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 aa2:	fae48de3          	beq	s1,a4,a5c <malloc+0x78>
        p->s.size -= nunits;
 aa6:	4137073b          	subw	a4,a4,s3
 aaa:	c798                	sw	a4,8(a5)
        p += p->s.size;
 aac:	02071693          	slli	a3,a4,0x20
 ab0:	01c6d713          	srli	a4,a3,0x1c
 ab4:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 ab6:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 aba:	00001717          	auipc	a4,0x1
 abe:	54a73323          	sd	a0,1350(a4) # 2000 <freep>
      return (void*)(p + 1);
 ac2:	01078513          	addi	a0,a5,16
  }
}
 ac6:	70e2                	ld	ra,56(sp)
 ac8:	7442                	ld	s0,48(sp)
 aca:	74a2                	ld	s1,40(sp)
 acc:	69e2                	ld	s3,24(sp)
 ace:	6121                	addi	sp,sp,64
 ad0:	8082                	ret
 ad2:	7902                	ld	s2,32(sp)
 ad4:	6a42                	ld	s4,16(sp)
 ad6:	6aa2                	ld	s5,8(sp)
 ad8:	6b02                	ld	s6,0(sp)
 ada:	b7f5                	j	ac6 <malloc+0xe2>
