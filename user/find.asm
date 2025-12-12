
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
   c:	b0850513          	addi	a0,a0,-1272 # b10 <malloc+0x102>
  10:	14b000ef          	jal	95a <printf>
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
  6e:	4cc000ef          	jal	53a <open>
    if (fd < 0) {
  72:	0c054763          	bltz	a0,140 <find+0xf2>
  76:	26913423          	sd	s1,616(sp)
  7a:	84aa                	mv	s1,a0
        printf("find: cannot open %s\n", path);
        return 0;//cannot be opened(not found)
    }
    // if statement de bt2ule lw this path is a file, directory

    if (fstat(fd, &st) < 0) {
  7c:	f9840593          	addi	a1,s0,-104
  80:	4d2000ef          	jal	552 <fstat>
  84:	0c054763          	bltz	a0,152 <find+0x104>
        printf("find: cannot stat %s\n", path);
        close(fd);
        return 0;
    }
    if (st.type != T_DIR) {
  88:	fa041703          	lh	a4,-96(s0)
  8c:	4785                	li	a5,1
    int found = 0; // flag to track if we found any match
  8e:	4a81                	li	s5,0
    if (st.type != T_DIR) {
  90:	0cf71f63          	bne	a4,a5,16e <find+0x120>
  94:	25613023          	sd	s6,576(sp)
  98:	23713c23          	sd	s7,568(sp)
    }

    // Directory case: scan contents
    while (read(fd, &de, sizeof(de)) == sizeof(de)) {
      //skip empty entries Skip . and .. "garbage entries"
        if (de.inum == 0 || strcmp(de.name, ".") == 0 ||strcmp(de.name, "..") == 0)
  9c:	00001b17          	auipc	s6,0x1
  a0:	aecb0b13          	addi	s6,s6,-1300 # b88 <malloc+0x17a>
  a4:	00001b97          	auipc	s7,0x1
  a8:	aecb8b93          	addi	s7,s7,-1300 # b90 <malloc+0x182>
    while (read(fd, &de, sizeof(de)) == sizeof(de)) {
  ac:	4641                	li	a2,16
  ae:	f8840593          	addi	a1,s0,-120
  b2:	8526                	mv	a0,s1
  b4:	45e000ef          	jal	512 <read>
  b8:	47c1                	li	a5,16
  ba:	14f51463          	bne	a0,a5,202 <find+0x1b4>
        if (de.inum == 0 || strcmp(de.name, ".") == 0 ||strcmp(de.name, "..") == 0)
  be:	f8845783          	lhu	a5,-120(s0)
  c2:	d7ed                	beqz	a5,ac <find+0x5e>
  c4:	85da                	mv	a1,s6
  c6:	f8a40513          	addi	a0,s0,-118
  ca:	1f4000ef          	jal	2be <strcmp>
  ce:	dd79                	beqz	a0,ac <find+0x5e>
  d0:	85de                	mv	a1,s7
  d2:	f8a40513          	addi	a0,s0,-118
  d6:	1e8000ef          	jal	2be <strcmp>
  da:	d969                	beqz	a0,ac <find+0x5e>
  dc:	25413823          	sd	s4,592(sp)
            continue;

        // Build full path: path + "/" + name ex: path=/home ,de.name=a.txt
        strcpy(buf, path); // bahut fl buffer /home
  e0:	85ca                	mv	a1,s2
  e2:	d8840513          	addi	a0,s0,-632
  e6:	1bc000ef          	jal	2a2 <strcpy>
        p = buf + strlen(buf);// khalet el pointery yb2a 3and end of string el howa "e"
  ea:	d8840513          	addi	a0,s0,-632
  ee:	1fc000ef          	jal	2ea <strlen>
  f2:	02051a13          	slli	s4,a0,0x20
  f6:	020a5a13          	srli	s4,s4,0x20
  fa:	d8840793          	addi	a5,s0,-632
  fe:	9a3e                	add	s4,s4,a5
        *p++ = '/';// add / ba3d /home f hatkon "/home/"
 100:	02f00793          	li	a5,47
 104:	00fa0023          	sb	a5,0(s4)
        memmove(p, de.name, DIRSIZ);//copy the 14 byte fixed filename
 108:	4639                	li	a2,14
 10a:	f8a40593          	addi	a1,s0,-118
 10e:	001a0513          	addi	a0,s4,1
 112:	33a000ef          	jal	44c <memmove>
        p[DIRSIZ] = 0; // null-terminate
 116:	000a07a3          	sb	zero,15(s4)

        if (stat(buf, &st) < 0 ) {//check filename with target
 11a:	f9840593          	addi	a1,s0,-104
 11e:	d8840513          	addi	a0,s0,-632
 122:	2a8000ef          	jal	3ca <stat>
 126:	06054263          	bltz	a0,18a <find+0x13c>
            printf("find: cannot stat %s\n", buf);
            continue;
        }

        // If directory → recurse, ex: /home/user/a.txt "ya3ne badawar gowa el home ba3den akhush 3ala user w adawar till i reach file"
        if ( st.type == T_DIR) {
 12a:	fa041783          	lh	a5,-96(s0)
 12e:	4705                	li	a4,1
 130:	06e78863          	beq	a5,a4,1a0 <find+0x152>
                // We do NOT set found=1, because we haven't found the FILE yet.
            }
            if (find(buf, target))
                found = 1; // if found in subdir, mark as found
        }
        else if (st.type == T_FILE) {
 134:	4709                	li	a4,2
 136:	08e78d63          	beq	a5,a4,1d0 <find+0x182>
 13a:	25013a03          	ld	s4,592(sp)
 13e:	b7bd                	j	ac <find+0x5e>
        printf("find: cannot open %s\n", path);
 140:	85ca                	mv	a1,s2
 142:	00001517          	auipc	a0,0x1
 146:	9f650513          	addi	a0,a0,-1546 # b38 <malloc+0x12a>
 14a:	011000ef          	jal	95a <printf>
        return 0;//cannot be opened(not found)
 14e:	4a81                	li	s5,0
 150:	a0d1                	j	214 <find+0x1c6>
        printf("find: cannot stat %s\n", path);
 152:	85ca                	mv	a1,s2
 154:	00001517          	auipc	a0,0x1
 158:	9fc50513          	addi	a0,a0,-1540 # b50 <malloc+0x142>
 15c:	7fe000ef          	jal	95a <printf>
        close(fd);
 160:	8526                	mv	a0,s1
 162:	3c0000ef          	jal	522 <close>
        return 0;
 166:	4a81                	li	s5,0
 168:	26813483          	ld	s1,616(sp)
 16c:	a065                	j	214 <find+0x1c6>
        printf("find: '%s' is not a directory\n", path);
 16e:	85ca                	mv	a1,s2
 170:	00001517          	auipc	a0,0x1
 174:	9f850513          	addi	a0,a0,-1544 # b68 <malloc+0x15a>
 178:	7e2000ef          	jal	95a <printf>
        close(fd);
 17c:	8526                	mv	a0,s1
 17e:	3a4000ef          	jal	522 <close>
        return 0;
 182:	4a81                	li	s5,0
 184:	26813483          	ld	s1,616(sp)
 188:	a071                	j	214 <find+0x1c6>
            printf("find: cannot stat %s\n", buf);
 18a:	d8840593          	addi	a1,s0,-632
 18e:	00001517          	auipc	a0,0x1
 192:	9c250513          	addi	a0,a0,-1598 # b50 <malloc+0x142>
 196:	7c4000ef          	jal	95a <printf>
            continue;
 19a:	25013a03          	ld	s4,592(sp)
 19e:	b739                	j	ac <find+0x5e>
            if (strcmp(de.name, target) == 0) {
 1a0:	85ce                	mv	a1,s3
 1a2:	f8a40513          	addi	a0,s0,-118
 1a6:	118000ef          	jal	2be <strcmp>
 1aa:	c911                	beqz	a0,1be <find+0x170>
            if (find(buf, target))
 1ac:	85ce                	mv	a1,s3
 1ae:	d8840513          	addi	a0,s0,-632
 1b2:	e9dff0ef          	jal	4e <find>
 1b6:	e131                	bnez	a0,1fa <find+0x1ac>
 1b8:	25013a03          	ld	s4,592(sp)
 1bc:	bdc5                	j	ac <find+0x5e>
                printf("find: '%s' is a directory, not a file\n", buf);
 1be:	d8840593          	addi	a1,s0,-632
 1c2:	00001517          	auipc	a0,0x1
 1c6:	9d650513          	addi	a0,a0,-1578 # b98 <malloc+0x18a>
 1ca:	790000ef          	jal	95a <printf>
 1ce:	bff9                	j	1ac <find+0x15e>
            // It is a file, NOW we check if the name matches the target
            if (strcmp(de.name, target) == 0) {
 1d0:	85ce                	mv	a1,s3
 1d2:	f8a40513          	addi	a0,s0,-118
 1d6:	0e8000ef          	jal	2be <strcmp>
 1da:	c501                	beqz	a0,1e2 <find+0x194>
 1dc:	25013a03          	ld	s4,592(sp)
 1e0:	b5f1                	j	ac <find+0x5e>
                printf("%s\n", buf);
 1e2:	d8840593          	addi	a1,s0,-632
 1e6:	00001517          	auipc	a0,0x1
 1ea:	9da50513          	addi	a0,a0,-1574 # bc0 <malloc+0x1b2>
 1ee:	76c000ef          	jal	95a <printf>
                found = 1;
 1f2:	4a85                	li	s5,1
 1f4:	25013a03          	ld	s4,592(sp)
 1f8:	bd55                	j	ac <find+0x5e>
                found = 1; // if found in subdir, mark as found
 1fa:	4a85                	li	s5,1
 1fc:	25013a03          	ld	s4,592(sp)
 200:	b575                	j	ac <find+0x5e>
            }
        }
    }


    close(fd);
 202:	8526                	mv	a0,s1
 204:	31e000ef          	jal	522 <close>
 208:	26813483          	ld	s1,616(sp)
 20c:	24013b03          	ld	s6,576(sp)
 210:	23813b83          	ld	s7,568(sp)
    return found;
}
 214:	8556                	mv	a0,s5
 216:	27813083          	ld	ra,632(sp)
 21a:	27013403          	ld	s0,624(sp)
 21e:	26013903          	ld	s2,608(sp)
 222:	25813983          	ld	s3,600(sp)
 226:	24813a83          	ld	s5,584(sp)
 22a:	28010113          	addi	sp,sp,640
 22e:	8082                	ret

0000000000000230 <main>:

int main(int argc, char *argv[]) {
 230:	1101                	addi	sp,sp,-32
 232:	ec06                	sd	ra,24(sp)
 234:	e822                	sd	s0,16(sp)
 236:	e426                	sd	s1,8(sp)
 238:	1000                	addi	s0,sp,32
 23a:	84ae                	mv	s1,a1
    if (argc == 2 && strcmp(argv[1], "?") == 0) {
 23c:	4789                	li	a5,2
 23e:	00f50a63          	beq	a0,a5,252 <main+0x22>
        print_help();
        exit(0);
    }

    if (argc != 3) {
 242:	478d                	li	a5,3
 244:	02f50463          	beq	a0,a5,26c <main+0x3c>
        print_help();
 248:	db9ff0ef          	jal	0 <print_help>
        exit(1);
 24c:	4505                	li	a0,1
 24e:	2ac000ef          	jal	4fa <exit>
    if (argc == 2 && strcmp(argv[1], "?") == 0) {
 252:	00001597          	auipc	a1,0x1
 256:	97658593          	addi	a1,a1,-1674 # bc8 <malloc+0x1ba>
 25a:	6488                	ld	a0,8(s1)
 25c:	062000ef          	jal	2be <strcmp>
 260:	f565                	bnez	a0,248 <main+0x18>
        print_help();
 262:	d9fff0ef          	jal	0 <print_help>
        exit(0);
 266:	4501                	li	a0,0
 268:	292000ef          	jal	4fa <exit>
    }

    // Call find and check if file was found
    if (!find(argv[1], argv[2])) {
 26c:	698c                	ld	a1,16(a1)
 26e:	6488                	ld	a0,8(s1)
 270:	ddfff0ef          	jal	4e <find>
 274:	e919                	bnez	a0,28a <main+0x5a>
        printf("find: file '%s' not found\n", argv[2]);
 276:	688c                	ld	a1,16(s1)
 278:	00001517          	auipc	a0,0x1
 27c:	95850513          	addi	a0,a0,-1704 # bd0 <malloc+0x1c2>
 280:	6da000ef          	jal	95a <printf>
        exit(1); // error code
 284:	4505                	li	a0,1
 286:	274000ef          	jal	4fa <exit>
    }

    exit(0);
 28a:	4501                	li	a0,0
 28c:	26e000ef          	jal	4fa <exit>

0000000000000290 <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start()
{
 290:	1141                	addi	sp,sp,-16
 292:	e406                	sd	ra,8(sp)
 294:	e022                	sd	s0,0(sp)
 296:	0800                	addi	s0,sp,16
  extern int main();
  main();
 298:	f99ff0ef          	jal	230 <main>
  exit(0);
 29c:	4501                	li	a0,0
 29e:	25c000ef          	jal	4fa <exit>

00000000000002a2 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
 2a2:	1141                	addi	sp,sp,-16
 2a4:	e422                	sd	s0,8(sp)
 2a6:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 2a8:	87aa                	mv	a5,a0
 2aa:	0585                	addi	a1,a1,1
 2ac:	0785                	addi	a5,a5,1
 2ae:	fff5c703          	lbu	a4,-1(a1)
 2b2:	fee78fa3          	sb	a4,-1(a5)
 2b6:	fb75                	bnez	a4,2aa <strcpy+0x8>
    ;
  return os;
}
 2b8:	6422                	ld	s0,8(sp)
 2ba:	0141                	addi	sp,sp,16
 2bc:	8082                	ret

00000000000002be <strcmp>:

int
strcmp(const char *p, const char *q)
{
 2be:	1141                	addi	sp,sp,-16
 2c0:	e422                	sd	s0,8(sp)
 2c2:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 2c4:	00054783          	lbu	a5,0(a0)
 2c8:	cb91                	beqz	a5,2dc <strcmp+0x1e>
 2ca:	0005c703          	lbu	a4,0(a1)
 2ce:	00f71763          	bne	a4,a5,2dc <strcmp+0x1e>
    p++, q++;
 2d2:	0505                	addi	a0,a0,1
 2d4:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 2d6:	00054783          	lbu	a5,0(a0)
 2da:	fbe5                	bnez	a5,2ca <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 2dc:	0005c503          	lbu	a0,0(a1)
}
 2e0:	40a7853b          	subw	a0,a5,a0
 2e4:	6422                	ld	s0,8(sp)
 2e6:	0141                	addi	sp,sp,16
 2e8:	8082                	ret

00000000000002ea <strlen>:

uint
strlen(const char *s)
{
 2ea:	1141                	addi	sp,sp,-16
 2ec:	e422                	sd	s0,8(sp)
 2ee:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 2f0:	00054783          	lbu	a5,0(a0)
 2f4:	cf91                	beqz	a5,310 <strlen+0x26>
 2f6:	0505                	addi	a0,a0,1
 2f8:	87aa                	mv	a5,a0
 2fa:	86be                	mv	a3,a5
 2fc:	0785                	addi	a5,a5,1
 2fe:	fff7c703          	lbu	a4,-1(a5)
 302:	ff65                	bnez	a4,2fa <strlen+0x10>
 304:	40a6853b          	subw	a0,a3,a0
 308:	2505                	addiw	a0,a0,1
    ;
  return n;
}
 30a:	6422                	ld	s0,8(sp)
 30c:	0141                	addi	sp,sp,16
 30e:	8082                	ret
  for(n = 0; s[n]; n++)
 310:	4501                	li	a0,0
 312:	bfe5                	j	30a <strlen+0x20>

0000000000000314 <memset>:

void*
memset(void *dst, int c, uint n)
{
 314:	1141                	addi	sp,sp,-16
 316:	e422                	sd	s0,8(sp)
 318:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 31a:	ca19                	beqz	a2,330 <memset+0x1c>
 31c:	87aa                	mv	a5,a0
 31e:	1602                	slli	a2,a2,0x20
 320:	9201                	srli	a2,a2,0x20
 322:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 326:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 32a:	0785                	addi	a5,a5,1
 32c:	fee79de3          	bne	a5,a4,326 <memset+0x12>
  }
  return dst;
}
 330:	6422                	ld	s0,8(sp)
 332:	0141                	addi	sp,sp,16
 334:	8082                	ret

0000000000000336 <strchr>:

char*
strchr(const char *s, char c)
{
 336:	1141                	addi	sp,sp,-16
 338:	e422                	sd	s0,8(sp)
 33a:	0800                	addi	s0,sp,16
  for(; *s; s++)
 33c:	00054783          	lbu	a5,0(a0)
 340:	cb99                	beqz	a5,356 <strchr+0x20>
    if(*s == c)
 342:	00f58763          	beq	a1,a5,350 <strchr+0x1a>
  for(; *s; s++)
 346:	0505                	addi	a0,a0,1
 348:	00054783          	lbu	a5,0(a0)
 34c:	fbfd                	bnez	a5,342 <strchr+0xc>
      return (char*)s;
  return 0;
 34e:	4501                	li	a0,0
}
 350:	6422                	ld	s0,8(sp)
 352:	0141                	addi	sp,sp,16
 354:	8082                	ret
  return 0;
 356:	4501                	li	a0,0
 358:	bfe5                	j	350 <strchr+0x1a>

000000000000035a <gets>:

char*
gets(char *buf, int max)
{
 35a:	711d                	addi	sp,sp,-96
 35c:	ec86                	sd	ra,88(sp)
 35e:	e8a2                	sd	s0,80(sp)
 360:	e4a6                	sd	s1,72(sp)
 362:	e0ca                	sd	s2,64(sp)
 364:	fc4e                	sd	s3,56(sp)
 366:	f852                	sd	s4,48(sp)
 368:	f456                	sd	s5,40(sp)
 36a:	f05a                	sd	s6,32(sp)
 36c:	ec5e                	sd	s7,24(sp)
 36e:	1080                	addi	s0,sp,96
 370:	8baa                	mv	s7,a0
 372:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 374:	892a                	mv	s2,a0
 376:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 378:	4aa9                	li	s5,10
 37a:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 37c:	89a6                	mv	s3,s1
 37e:	2485                	addiw	s1,s1,1
 380:	0344d663          	bge	s1,s4,3ac <gets+0x52>
    cc = read(0, &c, 1);
 384:	4605                	li	a2,1
 386:	faf40593          	addi	a1,s0,-81
 38a:	4501                	li	a0,0
 38c:	186000ef          	jal	512 <read>
    if(cc < 1)
 390:	00a05e63          	blez	a0,3ac <gets+0x52>
    buf[i++] = c;
 394:	faf44783          	lbu	a5,-81(s0)
 398:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 39c:	01578763          	beq	a5,s5,3aa <gets+0x50>
 3a0:	0905                	addi	s2,s2,1
 3a2:	fd679de3          	bne	a5,s6,37c <gets+0x22>
    buf[i++] = c;
 3a6:	89a6                	mv	s3,s1
 3a8:	a011                	j	3ac <gets+0x52>
 3aa:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 3ac:	99de                	add	s3,s3,s7
 3ae:	00098023          	sb	zero,0(s3)
  return buf;
}
 3b2:	855e                	mv	a0,s7
 3b4:	60e6                	ld	ra,88(sp)
 3b6:	6446                	ld	s0,80(sp)
 3b8:	64a6                	ld	s1,72(sp)
 3ba:	6906                	ld	s2,64(sp)
 3bc:	79e2                	ld	s3,56(sp)
 3be:	7a42                	ld	s4,48(sp)
 3c0:	7aa2                	ld	s5,40(sp)
 3c2:	7b02                	ld	s6,32(sp)
 3c4:	6be2                	ld	s7,24(sp)
 3c6:	6125                	addi	sp,sp,96
 3c8:	8082                	ret

00000000000003ca <stat>:

int
stat(const char *n, struct stat *st)
{
 3ca:	1101                	addi	sp,sp,-32
 3cc:	ec06                	sd	ra,24(sp)
 3ce:	e822                	sd	s0,16(sp)
 3d0:	e04a                	sd	s2,0(sp)
 3d2:	1000                	addi	s0,sp,32
 3d4:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 3d6:	4581                	li	a1,0
 3d8:	162000ef          	jal	53a <open>
  if(fd < 0)
 3dc:	02054263          	bltz	a0,400 <stat+0x36>
 3e0:	e426                	sd	s1,8(sp)
 3e2:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 3e4:	85ca                	mv	a1,s2
 3e6:	16c000ef          	jal	552 <fstat>
 3ea:	892a                	mv	s2,a0
  close(fd);
 3ec:	8526                	mv	a0,s1
 3ee:	134000ef          	jal	522 <close>
  return r;
 3f2:	64a2                	ld	s1,8(sp)
}
 3f4:	854a                	mv	a0,s2
 3f6:	60e2                	ld	ra,24(sp)
 3f8:	6442                	ld	s0,16(sp)
 3fa:	6902                	ld	s2,0(sp)
 3fc:	6105                	addi	sp,sp,32
 3fe:	8082                	ret
    return -1;
 400:	597d                	li	s2,-1
 402:	bfcd                	j	3f4 <stat+0x2a>

0000000000000404 <atoi>:

int
atoi(const char *s)
{
 404:	1141                	addi	sp,sp,-16
 406:	e422                	sd	s0,8(sp)
 408:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 40a:	00054683          	lbu	a3,0(a0)
 40e:	fd06879b          	addiw	a5,a3,-48
 412:	0ff7f793          	zext.b	a5,a5
 416:	4625                	li	a2,9
 418:	02f66863          	bltu	a2,a5,448 <atoi+0x44>
 41c:	872a                	mv	a4,a0
  n = 0;
 41e:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 420:	0705                	addi	a4,a4,1
 422:	0025179b          	slliw	a5,a0,0x2
 426:	9fa9                	addw	a5,a5,a0
 428:	0017979b          	slliw	a5,a5,0x1
 42c:	9fb5                	addw	a5,a5,a3
 42e:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 432:	00074683          	lbu	a3,0(a4)
 436:	fd06879b          	addiw	a5,a3,-48
 43a:	0ff7f793          	zext.b	a5,a5
 43e:	fef671e3          	bgeu	a2,a5,420 <atoi+0x1c>
  return n;
}
 442:	6422                	ld	s0,8(sp)
 444:	0141                	addi	sp,sp,16
 446:	8082                	ret
  n = 0;
 448:	4501                	li	a0,0
 44a:	bfe5                	j	442 <atoi+0x3e>

000000000000044c <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 44c:	1141                	addi	sp,sp,-16
 44e:	e422                	sd	s0,8(sp)
 450:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 452:	02b57463          	bgeu	a0,a1,47a <memmove+0x2e>
    while(n-- > 0)
 456:	00c05f63          	blez	a2,474 <memmove+0x28>
 45a:	1602                	slli	a2,a2,0x20
 45c:	9201                	srli	a2,a2,0x20
 45e:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 462:	872a                	mv	a4,a0
      *dst++ = *src++;
 464:	0585                	addi	a1,a1,1
 466:	0705                	addi	a4,a4,1
 468:	fff5c683          	lbu	a3,-1(a1)
 46c:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 470:	fef71ae3          	bne	a4,a5,464 <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 474:	6422                	ld	s0,8(sp)
 476:	0141                	addi	sp,sp,16
 478:	8082                	ret
    dst += n;
 47a:	00c50733          	add	a4,a0,a2
    src += n;
 47e:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 480:	fec05ae3          	blez	a2,474 <memmove+0x28>
 484:	fff6079b          	addiw	a5,a2,-1
 488:	1782                	slli	a5,a5,0x20
 48a:	9381                	srli	a5,a5,0x20
 48c:	fff7c793          	not	a5,a5
 490:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 492:	15fd                	addi	a1,a1,-1
 494:	177d                	addi	a4,a4,-1
 496:	0005c683          	lbu	a3,0(a1)
 49a:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 49e:	fee79ae3          	bne	a5,a4,492 <memmove+0x46>
 4a2:	bfc9                	j	474 <memmove+0x28>

00000000000004a4 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 4a4:	1141                	addi	sp,sp,-16
 4a6:	e422                	sd	s0,8(sp)
 4a8:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 4aa:	ca05                	beqz	a2,4da <memcmp+0x36>
 4ac:	fff6069b          	addiw	a3,a2,-1
 4b0:	1682                	slli	a3,a3,0x20
 4b2:	9281                	srli	a3,a3,0x20
 4b4:	0685                	addi	a3,a3,1
 4b6:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 4b8:	00054783          	lbu	a5,0(a0)
 4bc:	0005c703          	lbu	a4,0(a1)
 4c0:	00e79863          	bne	a5,a4,4d0 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 4c4:	0505                	addi	a0,a0,1
    p2++;
 4c6:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 4c8:	fed518e3          	bne	a0,a3,4b8 <memcmp+0x14>
  }
  return 0;
 4cc:	4501                	li	a0,0
 4ce:	a019                	j	4d4 <memcmp+0x30>
      return *p1 - *p2;
 4d0:	40e7853b          	subw	a0,a5,a4
}
 4d4:	6422                	ld	s0,8(sp)
 4d6:	0141                	addi	sp,sp,16
 4d8:	8082                	ret
  return 0;
 4da:	4501                	li	a0,0
 4dc:	bfe5                	j	4d4 <memcmp+0x30>

00000000000004de <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 4de:	1141                	addi	sp,sp,-16
 4e0:	e406                	sd	ra,8(sp)
 4e2:	e022                	sd	s0,0(sp)
 4e4:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 4e6:	f67ff0ef          	jal	44c <memmove>
}
 4ea:	60a2                	ld	ra,8(sp)
 4ec:	6402                	ld	s0,0(sp)
 4ee:	0141                	addi	sp,sp,16
 4f0:	8082                	ret

00000000000004f2 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 4f2:	4885                	li	a7,1
 ecall
 4f4:	00000073          	ecall
 ret
 4f8:	8082                	ret

00000000000004fa <exit>:
.global exit
exit:
 li a7, SYS_exit
 4fa:	4889                	li	a7,2
 ecall
 4fc:	00000073          	ecall
 ret
 500:	8082                	ret

0000000000000502 <wait>:
.global wait
wait:
 li a7, SYS_wait
 502:	488d                	li	a7,3
 ecall
 504:	00000073          	ecall
 ret
 508:	8082                	ret

000000000000050a <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 50a:	4891                	li	a7,4
 ecall
 50c:	00000073          	ecall
 ret
 510:	8082                	ret

0000000000000512 <read>:
.global read
read:
 li a7, SYS_read
 512:	4895                	li	a7,5
 ecall
 514:	00000073          	ecall
 ret
 518:	8082                	ret

000000000000051a <write>:
.global write
write:
 li a7, SYS_write
 51a:	48c1                	li	a7,16
 ecall
 51c:	00000073          	ecall
 ret
 520:	8082                	ret

0000000000000522 <close>:
.global close
close:
 li a7, SYS_close
 522:	48d5                	li	a7,21
 ecall
 524:	00000073          	ecall
 ret
 528:	8082                	ret

000000000000052a <kill>:
.global kill
kill:
 li a7, SYS_kill
 52a:	4899                	li	a7,6
 ecall
 52c:	00000073          	ecall
 ret
 530:	8082                	ret

0000000000000532 <exec>:
.global exec
exec:
 li a7, SYS_exec
 532:	489d                	li	a7,7
 ecall
 534:	00000073          	ecall
 ret
 538:	8082                	ret

000000000000053a <open>:
.global open
open:
 li a7, SYS_open
 53a:	48bd                	li	a7,15
 ecall
 53c:	00000073          	ecall
 ret
 540:	8082                	ret

0000000000000542 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 542:	48c5                	li	a7,17
 ecall
 544:	00000073          	ecall
 ret
 548:	8082                	ret

000000000000054a <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 54a:	48c9                	li	a7,18
 ecall
 54c:	00000073          	ecall
 ret
 550:	8082                	ret

0000000000000552 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 552:	48a1                	li	a7,8
 ecall
 554:	00000073          	ecall
 ret
 558:	8082                	ret

000000000000055a <link>:
.global link
link:
 li a7, SYS_link
 55a:	48cd                	li	a7,19
 ecall
 55c:	00000073          	ecall
 ret
 560:	8082                	ret

0000000000000562 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 562:	48d1                	li	a7,20
 ecall
 564:	00000073          	ecall
 ret
 568:	8082                	ret

000000000000056a <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 56a:	48a5                	li	a7,9
 ecall
 56c:	00000073          	ecall
 ret
 570:	8082                	ret

0000000000000572 <dup>:
.global dup
dup:
 li a7, SYS_dup
 572:	48a9                	li	a7,10
 ecall
 574:	00000073          	ecall
 ret
 578:	8082                	ret

000000000000057a <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 57a:	48ad                	li	a7,11
 ecall
 57c:	00000073          	ecall
 ret
 580:	8082                	ret

0000000000000582 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 582:	48b1                	li	a7,12
 ecall
 584:	00000073          	ecall
 ret
 588:	8082                	ret

000000000000058a <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 58a:	48b5                	li	a7,13
 ecall
 58c:	00000073          	ecall
 ret
 590:	8082                	ret

0000000000000592 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 592:	48b9                	li	a7,14
 ecall
 594:	00000073          	ecall
 ret
 598:	8082                	ret

000000000000059a <kbdint>:
.global kbdint
kbdint:
 li a7, SYS_kbdint
 59a:	48d9                	li	a7,22
 ecall
 59c:	00000073          	ecall
 ret
 5a0:	8082                	ret

00000000000005a2 <countsyscall>:
.global countsyscall
countsyscall:
 li a7, SYS_countsyscall
 5a2:	48dd                	li	a7,23
 ecall
 5a4:	00000073          	ecall
 ret
 5a8:	8082                	ret

00000000000005aa <getppid>:
.global getppid
getppid:
 li a7, SYS_getppid
 5aa:	48e1                	li	a7,24
 ecall
 5ac:	00000073          	ecall
 ret
 5b0:	8082                	ret

00000000000005b2 <shutdown>:
.global shutdown
shutdown:
 li a7, SYS_shutdown
 5b2:	48e5                	li	a7,25
 ecall
 5b4:	00000073          	ecall
 ret
 5b8:	8082                	ret

00000000000005ba <random>:
.global random
random:
 li a7, SYS_random
 5ba:	48e9                	li	a7,26
 ecall
 5bc:	00000073          	ecall
 ret
 5c0:	8082                	ret

00000000000005c2 <getptable>:
.global getptable
getptable:
 li a7, SYS_getptable
 5c2:	48ed                	li	a7,27
 ecall
 5c4:	00000073          	ecall
 ret
 5c8:	8082                	ret

00000000000005ca <datetime>:
.global datetime
datetime:
 li a7, SYS_datetime
 5ca:	48f1                	li	a7,28
 ecall
 5cc:	00000073          	ecall
 ret
 5d0:	8082                	ret

00000000000005d2 <set_sched>:
.global set_sched
set_sched:
 li a7, SYS_set_sched
 5d2:	48f5                	li	a7,29
 ecall
 5d4:	00000073          	ecall
 ret
 5d8:	8082                	ret

00000000000005da <wait_sched>:
.global wait_sched
wait_sched:
 li a7, SYS_wait_sched
 5da:	48f9                	li	a7,30
 ecall
 5dc:	00000073          	ecall
 ret
 5e0:	8082                	ret

00000000000005e2 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 5e2:	1101                	addi	sp,sp,-32
 5e4:	ec06                	sd	ra,24(sp)
 5e6:	e822                	sd	s0,16(sp)
 5e8:	1000                	addi	s0,sp,32
 5ea:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 5ee:	4605                	li	a2,1
 5f0:	fef40593          	addi	a1,s0,-17
 5f4:	f27ff0ef          	jal	51a <write>
}
 5f8:	60e2                	ld	ra,24(sp)
 5fa:	6442                	ld	s0,16(sp)
 5fc:	6105                	addi	sp,sp,32
 5fe:	8082                	ret

0000000000000600 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 600:	7139                	addi	sp,sp,-64
 602:	fc06                	sd	ra,56(sp)
 604:	f822                	sd	s0,48(sp)
 606:	f426                	sd	s1,40(sp)
 608:	0080                	addi	s0,sp,64
 60a:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 60c:	c299                	beqz	a3,612 <printint+0x12>
 60e:	0805c963          	bltz	a1,6a0 <printint+0xa0>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 612:	2581                	sext.w	a1,a1
  neg = 0;
 614:	4881                	li	a7,0
 616:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 61a:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 61c:	2601                	sext.w	a2,a2
 61e:	00000517          	auipc	a0,0x0
 622:	5da50513          	addi	a0,a0,1498 # bf8 <digits>
 626:	883a                	mv	a6,a4
 628:	2705                	addiw	a4,a4,1
 62a:	02c5f7bb          	remuw	a5,a1,a2
 62e:	1782                	slli	a5,a5,0x20
 630:	9381                	srli	a5,a5,0x20
 632:	97aa                	add	a5,a5,a0
 634:	0007c783          	lbu	a5,0(a5)
 638:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 63c:	0005879b          	sext.w	a5,a1
 640:	02c5d5bb          	divuw	a1,a1,a2
 644:	0685                	addi	a3,a3,1
 646:	fec7f0e3          	bgeu	a5,a2,626 <printint+0x26>
  if(neg)
 64a:	00088c63          	beqz	a7,662 <printint+0x62>
    buf[i++] = '-';
 64e:	fd070793          	addi	a5,a4,-48
 652:	00878733          	add	a4,a5,s0
 656:	02d00793          	li	a5,45
 65a:	fef70823          	sb	a5,-16(a4)
 65e:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 662:	02e05a63          	blez	a4,696 <printint+0x96>
 666:	f04a                	sd	s2,32(sp)
 668:	ec4e                	sd	s3,24(sp)
 66a:	fc040793          	addi	a5,s0,-64
 66e:	00e78933          	add	s2,a5,a4
 672:	fff78993          	addi	s3,a5,-1
 676:	99ba                	add	s3,s3,a4
 678:	377d                	addiw	a4,a4,-1
 67a:	1702                	slli	a4,a4,0x20
 67c:	9301                	srli	a4,a4,0x20
 67e:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 682:	fff94583          	lbu	a1,-1(s2)
 686:	8526                	mv	a0,s1
 688:	f5bff0ef          	jal	5e2 <putc>
  while(--i >= 0)
 68c:	197d                	addi	s2,s2,-1
 68e:	ff391ae3          	bne	s2,s3,682 <printint+0x82>
 692:	7902                	ld	s2,32(sp)
 694:	69e2                	ld	s3,24(sp)
}
 696:	70e2                	ld	ra,56(sp)
 698:	7442                	ld	s0,48(sp)
 69a:	74a2                	ld	s1,40(sp)
 69c:	6121                	addi	sp,sp,64
 69e:	8082                	ret
    x = -xx;
 6a0:	40b005bb          	negw	a1,a1
    neg = 1;
 6a4:	4885                	li	a7,1
    x = -xx;
 6a6:	bf85                	j	616 <printint+0x16>

00000000000006a8 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 6a8:	711d                	addi	sp,sp,-96
 6aa:	ec86                	sd	ra,88(sp)
 6ac:	e8a2                	sd	s0,80(sp)
 6ae:	e0ca                	sd	s2,64(sp)
 6b0:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 6b2:	0005c903          	lbu	s2,0(a1)
 6b6:	26090863          	beqz	s2,926 <vprintf+0x27e>
 6ba:	e4a6                	sd	s1,72(sp)
 6bc:	fc4e                	sd	s3,56(sp)
 6be:	f852                	sd	s4,48(sp)
 6c0:	f456                	sd	s5,40(sp)
 6c2:	f05a                	sd	s6,32(sp)
 6c4:	ec5e                	sd	s7,24(sp)
 6c6:	e862                	sd	s8,16(sp)
 6c8:	e466                	sd	s9,8(sp)
 6ca:	8b2a                	mv	s6,a0
 6cc:	8a2e                	mv	s4,a1
 6ce:	8bb2                	mv	s7,a2
  state = 0;
 6d0:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 6d2:	4481                	li	s1,0
 6d4:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 6d6:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 6da:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 6de:	06c00c93          	li	s9,108
 6e2:	a005                	j	702 <vprintf+0x5a>
        putc(fd, c0);
 6e4:	85ca                	mv	a1,s2
 6e6:	855a                	mv	a0,s6
 6e8:	efbff0ef          	jal	5e2 <putc>
 6ec:	a019                	j	6f2 <vprintf+0x4a>
    } else if(state == '%'){
 6ee:	03598263          	beq	s3,s5,712 <vprintf+0x6a>
  for(i = 0; fmt[i]; i++){
 6f2:	2485                	addiw	s1,s1,1
 6f4:	8726                	mv	a4,s1
 6f6:	009a07b3          	add	a5,s4,s1
 6fa:	0007c903          	lbu	s2,0(a5)
 6fe:	20090c63          	beqz	s2,916 <vprintf+0x26e>
    c0 = fmt[i] & 0xff;
 702:	0009079b          	sext.w	a5,s2
    if(state == 0){
 706:	fe0994e3          	bnez	s3,6ee <vprintf+0x46>
      if(c0 == '%'){
 70a:	fd579de3          	bne	a5,s5,6e4 <vprintf+0x3c>
        state = '%';
 70e:	89be                	mv	s3,a5
 710:	b7cd                	j	6f2 <vprintf+0x4a>
      if(c0) c1 = fmt[i+1] & 0xff;
 712:	00ea06b3          	add	a3,s4,a4
 716:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 71a:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
 71c:	c681                	beqz	a3,724 <vprintf+0x7c>
 71e:	9752                	add	a4,a4,s4
 720:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
 724:	03878f63          	beq	a5,s8,762 <vprintf+0xba>
      } else if(c0 == 'l' && c1 == 'd'){
 728:	05978963          	beq	a5,s9,77a <vprintf+0xd2>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
 72c:	07500713          	li	a4,117
 730:	0ee78363          	beq	a5,a4,816 <vprintf+0x16e>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
 734:	07800713          	li	a4,120
 738:	12e78563          	beq	a5,a4,862 <vprintf+0x1ba>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
 73c:	07000713          	li	a4,112
 740:	14e78a63          	beq	a5,a4,894 <vprintf+0x1ec>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 's'){
 744:	07300713          	li	a4,115
 748:	18e78a63          	beq	a5,a4,8dc <vprintf+0x234>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
 74c:	02500713          	li	a4,37
 750:	04e79563          	bne	a5,a4,79a <vprintf+0xf2>
        putc(fd, '%');
 754:	02500593          	li	a1,37
 758:	855a                	mv	a0,s6
 75a:	e89ff0ef          	jal	5e2 <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
#endif
      state = 0;
 75e:	4981                	li	s3,0
 760:	bf49                	j	6f2 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 1);
 762:	008b8913          	addi	s2,s7,8
 766:	4685                	li	a3,1
 768:	4629                	li	a2,10
 76a:	000ba583          	lw	a1,0(s7)
 76e:	855a                	mv	a0,s6
 770:	e91ff0ef          	jal	600 <printint>
 774:	8bca                	mv	s7,s2
      state = 0;
 776:	4981                	li	s3,0
 778:	bfad                	j	6f2 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'd'){
 77a:	06400793          	li	a5,100
 77e:	02f68963          	beq	a3,a5,7b0 <vprintf+0x108>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 782:	06c00793          	li	a5,108
 786:	04f68263          	beq	a3,a5,7ca <vprintf+0x122>
      } else if(c0 == 'l' && c1 == 'u'){
 78a:	07500793          	li	a5,117
 78e:	0af68063          	beq	a3,a5,82e <vprintf+0x186>
      } else if(c0 == 'l' && c1 == 'x'){
 792:	07800793          	li	a5,120
 796:	0ef68263          	beq	a3,a5,87a <vprintf+0x1d2>
        putc(fd, '%');
 79a:	02500593          	li	a1,37
 79e:	855a                	mv	a0,s6
 7a0:	e43ff0ef          	jal	5e2 <putc>
        putc(fd, c0);
 7a4:	85ca                	mv	a1,s2
 7a6:	855a                	mv	a0,s6
 7a8:	e3bff0ef          	jal	5e2 <putc>
      state = 0;
 7ac:	4981                	li	s3,0
 7ae:	b791                	j	6f2 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 7b0:	008b8913          	addi	s2,s7,8
 7b4:	4685                	li	a3,1
 7b6:	4629                	li	a2,10
 7b8:	000ba583          	lw	a1,0(s7)
 7bc:	855a                	mv	a0,s6
 7be:	e43ff0ef          	jal	600 <printint>
        i += 1;
 7c2:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 7c4:	8bca                	mv	s7,s2
      state = 0;
 7c6:	4981                	li	s3,0
        i += 1;
 7c8:	b72d                	j	6f2 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 7ca:	06400793          	li	a5,100
 7ce:	02f60763          	beq	a2,a5,7fc <vprintf+0x154>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 7d2:	07500793          	li	a5,117
 7d6:	06f60963          	beq	a2,a5,848 <vprintf+0x1a0>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 7da:	07800793          	li	a5,120
 7de:	faf61ee3          	bne	a2,a5,79a <vprintf+0xf2>
        printint(fd, va_arg(ap, uint64), 16, 0);
 7e2:	008b8913          	addi	s2,s7,8
 7e6:	4681                	li	a3,0
 7e8:	4641                	li	a2,16
 7ea:	000ba583          	lw	a1,0(s7)
 7ee:	855a                	mv	a0,s6
 7f0:	e11ff0ef          	jal	600 <printint>
        i += 2;
 7f4:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 7f6:	8bca                	mv	s7,s2
      state = 0;
 7f8:	4981                	li	s3,0
        i += 2;
 7fa:	bde5                	j	6f2 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 7fc:	008b8913          	addi	s2,s7,8
 800:	4685                	li	a3,1
 802:	4629                	li	a2,10
 804:	000ba583          	lw	a1,0(s7)
 808:	855a                	mv	a0,s6
 80a:	df7ff0ef          	jal	600 <printint>
        i += 2;
 80e:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 810:	8bca                	mv	s7,s2
      state = 0;
 812:	4981                	li	s3,0
        i += 2;
 814:	bdf9                	j	6f2 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 0);
 816:	008b8913          	addi	s2,s7,8
 81a:	4681                	li	a3,0
 81c:	4629                	li	a2,10
 81e:	000ba583          	lw	a1,0(s7)
 822:	855a                	mv	a0,s6
 824:	dddff0ef          	jal	600 <printint>
 828:	8bca                	mv	s7,s2
      state = 0;
 82a:	4981                	li	s3,0
 82c:	b5d9                	j	6f2 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 82e:	008b8913          	addi	s2,s7,8
 832:	4681                	li	a3,0
 834:	4629                	li	a2,10
 836:	000ba583          	lw	a1,0(s7)
 83a:	855a                	mv	a0,s6
 83c:	dc5ff0ef          	jal	600 <printint>
        i += 1;
 840:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 842:	8bca                	mv	s7,s2
      state = 0;
 844:	4981                	li	s3,0
        i += 1;
 846:	b575                	j	6f2 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 848:	008b8913          	addi	s2,s7,8
 84c:	4681                	li	a3,0
 84e:	4629                	li	a2,10
 850:	000ba583          	lw	a1,0(s7)
 854:	855a                	mv	a0,s6
 856:	dabff0ef          	jal	600 <printint>
        i += 2;
 85a:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 85c:	8bca                	mv	s7,s2
      state = 0;
 85e:	4981                	li	s3,0
        i += 2;
 860:	bd49                	j	6f2 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 16, 0);
 862:	008b8913          	addi	s2,s7,8
 866:	4681                	li	a3,0
 868:	4641                	li	a2,16
 86a:	000ba583          	lw	a1,0(s7)
 86e:	855a                	mv	a0,s6
 870:	d91ff0ef          	jal	600 <printint>
 874:	8bca                	mv	s7,s2
      state = 0;
 876:	4981                	li	s3,0
 878:	bdad                	j	6f2 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 16, 0);
 87a:	008b8913          	addi	s2,s7,8
 87e:	4681                	li	a3,0
 880:	4641                	li	a2,16
 882:	000ba583          	lw	a1,0(s7)
 886:	855a                	mv	a0,s6
 888:	d79ff0ef          	jal	600 <printint>
        i += 1;
 88c:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 88e:	8bca                	mv	s7,s2
      state = 0;
 890:	4981                	li	s3,0
        i += 1;
 892:	b585                	j	6f2 <vprintf+0x4a>
 894:	e06a                	sd	s10,0(sp)
        printptr(fd, va_arg(ap, uint64));
 896:	008b8d13          	addi	s10,s7,8
 89a:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 89e:	03000593          	li	a1,48
 8a2:	855a                	mv	a0,s6
 8a4:	d3fff0ef          	jal	5e2 <putc>
  putc(fd, 'x');
 8a8:	07800593          	li	a1,120
 8ac:	855a                	mv	a0,s6
 8ae:	d35ff0ef          	jal	5e2 <putc>
 8b2:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 8b4:	00000b97          	auipc	s7,0x0
 8b8:	344b8b93          	addi	s7,s7,836 # bf8 <digits>
 8bc:	03c9d793          	srli	a5,s3,0x3c
 8c0:	97de                	add	a5,a5,s7
 8c2:	0007c583          	lbu	a1,0(a5)
 8c6:	855a                	mv	a0,s6
 8c8:	d1bff0ef          	jal	5e2 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 8cc:	0992                	slli	s3,s3,0x4
 8ce:	397d                	addiw	s2,s2,-1
 8d0:	fe0916e3          	bnez	s2,8bc <vprintf+0x214>
        printptr(fd, va_arg(ap, uint64));
 8d4:	8bea                	mv	s7,s10
      state = 0;
 8d6:	4981                	li	s3,0
 8d8:	6d02                	ld	s10,0(sp)
 8da:	bd21                	j	6f2 <vprintf+0x4a>
        if((s = va_arg(ap, char*)) == 0)
 8dc:	008b8993          	addi	s3,s7,8
 8e0:	000bb903          	ld	s2,0(s7)
 8e4:	00090f63          	beqz	s2,902 <vprintf+0x25a>
        for(; *s; s++)
 8e8:	00094583          	lbu	a1,0(s2)
 8ec:	c195                	beqz	a1,910 <vprintf+0x268>
          putc(fd, *s);
 8ee:	855a                	mv	a0,s6
 8f0:	cf3ff0ef          	jal	5e2 <putc>
        for(; *s; s++)
 8f4:	0905                	addi	s2,s2,1
 8f6:	00094583          	lbu	a1,0(s2)
 8fa:	f9f5                	bnez	a1,8ee <vprintf+0x246>
        if((s = va_arg(ap, char*)) == 0)
 8fc:	8bce                	mv	s7,s3
      state = 0;
 8fe:	4981                	li	s3,0
 900:	bbcd                	j	6f2 <vprintf+0x4a>
          s = "(null)";
 902:	00000917          	auipc	s2,0x0
 906:	2ee90913          	addi	s2,s2,750 # bf0 <malloc+0x1e2>
        for(; *s; s++)
 90a:	02800593          	li	a1,40
 90e:	b7c5                	j	8ee <vprintf+0x246>
        if((s = va_arg(ap, char*)) == 0)
 910:	8bce                	mv	s7,s3
      state = 0;
 912:	4981                	li	s3,0
 914:	bbf9                	j	6f2 <vprintf+0x4a>
 916:	64a6                	ld	s1,72(sp)
 918:	79e2                	ld	s3,56(sp)
 91a:	7a42                	ld	s4,48(sp)
 91c:	7aa2                	ld	s5,40(sp)
 91e:	7b02                	ld	s6,32(sp)
 920:	6be2                	ld	s7,24(sp)
 922:	6c42                	ld	s8,16(sp)
 924:	6ca2                	ld	s9,8(sp)
    }
  }
}
 926:	60e6                	ld	ra,88(sp)
 928:	6446                	ld	s0,80(sp)
 92a:	6906                	ld	s2,64(sp)
 92c:	6125                	addi	sp,sp,96
 92e:	8082                	ret

0000000000000930 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 930:	715d                	addi	sp,sp,-80
 932:	ec06                	sd	ra,24(sp)
 934:	e822                	sd	s0,16(sp)
 936:	1000                	addi	s0,sp,32
 938:	e010                	sd	a2,0(s0)
 93a:	e414                	sd	a3,8(s0)
 93c:	e818                	sd	a4,16(s0)
 93e:	ec1c                	sd	a5,24(s0)
 940:	03043023          	sd	a6,32(s0)
 944:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 948:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 94c:	8622                	mv	a2,s0
 94e:	d5bff0ef          	jal	6a8 <vprintf>
}
 952:	60e2                	ld	ra,24(sp)
 954:	6442                	ld	s0,16(sp)
 956:	6161                	addi	sp,sp,80
 958:	8082                	ret

000000000000095a <printf>:

void
printf(const char *fmt, ...)
{
 95a:	711d                	addi	sp,sp,-96
 95c:	ec06                	sd	ra,24(sp)
 95e:	e822                	sd	s0,16(sp)
 960:	1000                	addi	s0,sp,32
 962:	e40c                	sd	a1,8(s0)
 964:	e810                	sd	a2,16(s0)
 966:	ec14                	sd	a3,24(s0)
 968:	f018                	sd	a4,32(s0)
 96a:	f41c                	sd	a5,40(s0)
 96c:	03043823          	sd	a6,48(s0)
 970:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 974:	00840613          	addi	a2,s0,8
 978:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 97c:	85aa                	mv	a1,a0
 97e:	4505                	li	a0,1
 980:	d29ff0ef          	jal	6a8 <vprintf>
}
 984:	60e2                	ld	ra,24(sp)
 986:	6442                	ld	s0,16(sp)
 988:	6125                	addi	sp,sp,96
 98a:	8082                	ret

000000000000098c <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 98c:	1141                	addi	sp,sp,-16
 98e:	e422                	sd	s0,8(sp)
 990:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 992:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 996:	00001797          	auipc	a5,0x1
 99a:	66a7b783          	ld	a5,1642(a5) # 2000 <freep>
 99e:	a02d                	j	9c8 <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 9a0:	4618                	lw	a4,8(a2)
 9a2:	9f2d                	addw	a4,a4,a1
 9a4:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 9a8:	6398                	ld	a4,0(a5)
 9aa:	6310                	ld	a2,0(a4)
 9ac:	a83d                	j	9ea <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 9ae:	ff852703          	lw	a4,-8(a0)
 9b2:	9f31                	addw	a4,a4,a2
 9b4:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 9b6:	ff053683          	ld	a3,-16(a0)
 9ba:	a091                	j	9fe <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 9bc:	6398                	ld	a4,0(a5)
 9be:	00e7e463          	bltu	a5,a4,9c6 <free+0x3a>
 9c2:	00e6ea63          	bltu	a3,a4,9d6 <free+0x4a>
{
 9c6:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 9c8:	fed7fae3          	bgeu	a5,a3,9bc <free+0x30>
 9cc:	6398                	ld	a4,0(a5)
 9ce:	00e6e463          	bltu	a3,a4,9d6 <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 9d2:	fee7eae3          	bltu	a5,a4,9c6 <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 9d6:	ff852583          	lw	a1,-8(a0)
 9da:	6390                	ld	a2,0(a5)
 9dc:	02059813          	slli	a6,a1,0x20
 9e0:	01c85713          	srli	a4,a6,0x1c
 9e4:	9736                	add	a4,a4,a3
 9e6:	fae60de3          	beq	a2,a4,9a0 <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 9ea:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 9ee:	4790                	lw	a2,8(a5)
 9f0:	02061593          	slli	a1,a2,0x20
 9f4:	01c5d713          	srli	a4,a1,0x1c
 9f8:	973e                	add	a4,a4,a5
 9fa:	fae68ae3          	beq	a3,a4,9ae <free+0x22>
    p->s.ptr = bp->s.ptr;
 9fe:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 a00:	00001717          	auipc	a4,0x1
 a04:	60f73023          	sd	a5,1536(a4) # 2000 <freep>
}
 a08:	6422                	ld	s0,8(sp)
 a0a:	0141                	addi	sp,sp,16
 a0c:	8082                	ret

0000000000000a0e <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 a0e:	7139                	addi	sp,sp,-64
 a10:	fc06                	sd	ra,56(sp)
 a12:	f822                	sd	s0,48(sp)
 a14:	f426                	sd	s1,40(sp)
 a16:	ec4e                	sd	s3,24(sp)
 a18:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 a1a:	02051493          	slli	s1,a0,0x20
 a1e:	9081                	srli	s1,s1,0x20
 a20:	04bd                	addi	s1,s1,15
 a22:	8091                	srli	s1,s1,0x4
 a24:	0014899b          	addiw	s3,s1,1
 a28:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 a2a:	00001517          	auipc	a0,0x1
 a2e:	5d653503          	ld	a0,1494(a0) # 2000 <freep>
 a32:	c915                	beqz	a0,a66 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 a34:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 a36:	4798                	lw	a4,8(a5)
 a38:	08977a63          	bgeu	a4,s1,acc <malloc+0xbe>
 a3c:	f04a                	sd	s2,32(sp)
 a3e:	e852                	sd	s4,16(sp)
 a40:	e456                	sd	s5,8(sp)
 a42:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 a44:	8a4e                	mv	s4,s3
 a46:	0009871b          	sext.w	a4,s3
 a4a:	6685                	lui	a3,0x1
 a4c:	00d77363          	bgeu	a4,a3,a52 <malloc+0x44>
 a50:	6a05                	lui	s4,0x1
 a52:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 a56:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 a5a:	00001917          	auipc	s2,0x1
 a5e:	5a690913          	addi	s2,s2,1446 # 2000 <freep>
  if(p == (char*)-1)
 a62:	5afd                	li	s5,-1
 a64:	a081                	j	aa4 <malloc+0x96>
 a66:	f04a                	sd	s2,32(sp)
 a68:	e852                	sd	s4,16(sp)
 a6a:	e456                	sd	s5,8(sp)
 a6c:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 a6e:	00001797          	auipc	a5,0x1
 a72:	5a278793          	addi	a5,a5,1442 # 2010 <base>
 a76:	00001717          	auipc	a4,0x1
 a7a:	58f73523          	sd	a5,1418(a4) # 2000 <freep>
 a7e:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 a80:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 a84:	b7c1                	j	a44 <malloc+0x36>
        prevp->s.ptr = p->s.ptr;
 a86:	6398                	ld	a4,0(a5)
 a88:	e118                	sd	a4,0(a0)
 a8a:	a8a9                	j	ae4 <malloc+0xd6>
  hp->s.size = nu;
 a8c:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 a90:	0541                	addi	a0,a0,16
 a92:	efbff0ef          	jal	98c <free>
  return freep;
 a96:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 a9a:	c12d                	beqz	a0,afc <malloc+0xee>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 a9c:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 a9e:	4798                	lw	a4,8(a5)
 aa0:	02977263          	bgeu	a4,s1,ac4 <malloc+0xb6>
    if(p == freep)
 aa4:	00093703          	ld	a4,0(s2)
 aa8:	853e                	mv	a0,a5
 aaa:	fef719e3          	bne	a4,a5,a9c <malloc+0x8e>
  p = sbrk(nu * sizeof(Header));
 aae:	8552                	mv	a0,s4
 ab0:	ad3ff0ef          	jal	582 <sbrk>
  if(p == (char*)-1)
 ab4:	fd551ce3          	bne	a0,s5,a8c <malloc+0x7e>
        return 0;
 ab8:	4501                	li	a0,0
 aba:	7902                	ld	s2,32(sp)
 abc:	6a42                	ld	s4,16(sp)
 abe:	6aa2                	ld	s5,8(sp)
 ac0:	6b02                	ld	s6,0(sp)
 ac2:	a03d                	j	af0 <malloc+0xe2>
 ac4:	7902                	ld	s2,32(sp)
 ac6:	6a42                	ld	s4,16(sp)
 ac8:	6aa2                	ld	s5,8(sp)
 aca:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 acc:	fae48de3          	beq	s1,a4,a86 <malloc+0x78>
        p->s.size -= nunits;
 ad0:	4137073b          	subw	a4,a4,s3
 ad4:	c798                	sw	a4,8(a5)
        p += p->s.size;
 ad6:	02071693          	slli	a3,a4,0x20
 ada:	01c6d713          	srli	a4,a3,0x1c
 ade:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 ae0:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 ae4:	00001717          	auipc	a4,0x1
 ae8:	50a73e23          	sd	a0,1308(a4) # 2000 <freep>
      return (void*)(p + 1);
 aec:	01078513          	addi	a0,a5,16
  }
}
 af0:	70e2                	ld	ra,56(sp)
 af2:	7442                	ld	s0,48(sp)
 af4:	74a2                	ld	s1,40(sp)
 af6:	69e2                	ld	s3,24(sp)
 af8:	6121                	addi	sp,sp,64
 afa:	8082                	ret
 afc:	7902                	ld	s2,32(sp)
 afe:	6a42                	ld	s4,16(sp)
 b00:	6aa2                	ld	s5,8(sp)
 b02:	6b02                	ld	s6,0(sp)
 b04:	b7f5                	j	af0 <malloc+0xe2>
