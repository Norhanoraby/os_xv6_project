
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
   c:	ad850513          	addi	a0,a0,-1320 # ae0 <malloc+0x104>
  10:	119000ef          	jal	928 <printf>
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
  a0:	aa4b0b13          	addi	s6,s6,-1372 # b40 <malloc+0x164>
  a4:	00001b97          	auipc	s7,0x1
  a8:	aa4b8b93          	addi	s7,s7,-1372 # b48 <malloc+0x16c>
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
 148:	9c450513          	addi	a0,a0,-1596 # b08 <malloc+0x12c>
 14c:	7dc000ef          	jal	928 <printf>
        return 0;//cannot be opened(not found)
 150:	4a81                	li	s5,0
 152:	a845                	j	202 <find+0x1b4>
        printf("find: cannot stat %s\n", path);
 154:	85ca                	mv	a1,s2
 156:	00001517          	auipc	a0,0x1
 15a:	9ca50513          	addi	a0,a0,-1590 # b20 <malloc+0x144>
 15e:	7ca000ef          	jal	928 <printf>
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
 1b0:	98c50513          	addi	a0,a0,-1652 # b38 <malloc+0x15c>
 1b4:	774000ef          	jal	928 <printf>
            found = 1;
 1b8:	4a85                	li	s5,1
 1ba:	b7d5                	j	19e <find+0x150>
            printf("%s\n", buf);//print the full path
 1bc:	d8840593          	addi	a1,s0,-632
 1c0:	00001517          	auipc	a0,0x1
 1c4:	97850513          	addi	a0,a0,-1672 # b38 <malloc+0x15c>
 1c8:	760000ef          	jal	928 <printf>
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
 244:	91058593          	addi	a1,a1,-1776 # b50 <malloc+0x174>
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
 26a:	8f250513          	addi	a0,a0,-1806 # b58 <malloc+0x17c>
 26e:	6ba000ef          	jal	928 <printf>
        exit(1); // error code
 272:	4505                	li	a0,1
 274:	274000ef          	jal	4e8 <exit>
    }

    exit(0);
 278:	4501                	li	a0,0
 27a:	26e000ef          	jal	4e8 <exit>

000000000000027e <start>:
 27e:	1141                	addi	sp,sp,-16
 280:	e406                	sd	ra,8(sp)
 282:	e022                	sd	s0,0(sp)
 284:	0800                	addi	s0,sp,16
 286:	f99ff0ef          	jal	21e <main>
 28a:	4501                	li	a0,0
 28c:	25c000ef          	jal	4e8 <exit>

0000000000000290 <strcpy>:
 290:	1141                	addi	sp,sp,-16
 292:	e422                	sd	s0,8(sp)
 294:	0800                	addi	s0,sp,16
 296:	87aa                	mv	a5,a0
 298:	0585                	addi	a1,a1,1
 29a:	0785                	addi	a5,a5,1
 29c:	fff5c703          	lbu	a4,-1(a1)
 2a0:	fee78fa3          	sb	a4,-1(a5)
 2a4:	fb75                	bnez	a4,298 <strcpy+0x8>
 2a6:	6422                	ld	s0,8(sp)
 2a8:	0141                	addi	sp,sp,16
 2aa:	8082                	ret

00000000000002ac <strcmp>:
 2ac:	1141                	addi	sp,sp,-16
 2ae:	e422                	sd	s0,8(sp)
 2b0:	0800                	addi	s0,sp,16
 2b2:	00054783          	lbu	a5,0(a0)
 2b6:	cb91                	beqz	a5,2ca <strcmp+0x1e>
 2b8:	0005c703          	lbu	a4,0(a1)
 2bc:	00f71763          	bne	a4,a5,2ca <strcmp+0x1e>
 2c0:	0505                	addi	a0,a0,1
 2c2:	0585                	addi	a1,a1,1
 2c4:	00054783          	lbu	a5,0(a0)
 2c8:	fbe5                	bnez	a5,2b8 <strcmp+0xc>
 2ca:	0005c503          	lbu	a0,0(a1)
 2ce:	40a7853b          	subw	a0,a5,a0
 2d2:	6422                	ld	s0,8(sp)
 2d4:	0141                	addi	sp,sp,16
 2d6:	8082                	ret

00000000000002d8 <strlen>:
 2d8:	1141                	addi	sp,sp,-16
 2da:	e422                	sd	s0,8(sp)
 2dc:	0800                	addi	s0,sp,16
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
 2f8:	6422                	ld	s0,8(sp)
 2fa:	0141                	addi	sp,sp,16
 2fc:	8082                	ret
 2fe:	4501                	li	a0,0
 300:	bfe5                	j	2f8 <strlen+0x20>

0000000000000302 <memset>:
 302:	1141                	addi	sp,sp,-16
 304:	e422                	sd	s0,8(sp)
 306:	0800                	addi	s0,sp,16
 308:	ca19                	beqz	a2,31e <memset+0x1c>
 30a:	87aa                	mv	a5,a0
 30c:	1602                	slli	a2,a2,0x20
 30e:	9201                	srli	a2,a2,0x20
 310:	00a60733          	add	a4,a2,a0
 314:	00b78023          	sb	a1,0(a5)
 318:	0785                	addi	a5,a5,1
 31a:	fee79de3          	bne	a5,a4,314 <memset+0x12>
 31e:	6422                	ld	s0,8(sp)
 320:	0141                	addi	sp,sp,16
 322:	8082                	ret

0000000000000324 <strchr>:
 324:	1141                	addi	sp,sp,-16
 326:	e422                	sd	s0,8(sp)
 328:	0800                	addi	s0,sp,16
 32a:	00054783          	lbu	a5,0(a0)
 32e:	cb99                	beqz	a5,344 <strchr+0x20>
 330:	00f58763          	beq	a1,a5,33e <strchr+0x1a>
 334:	0505                	addi	a0,a0,1
 336:	00054783          	lbu	a5,0(a0)
 33a:	fbfd                	bnez	a5,330 <strchr+0xc>
 33c:	4501                	li	a0,0
 33e:	6422                	ld	s0,8(sp)
 340:	0141                	addi	sp,sp,16
 342:	8082                	ret
 344:	4501                	li	a0,0
 346:	bfe5                	j	33e <strchr+0x1a>

0000000000000348 <gets>:
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
 362:	892a                	mv	s2,a0
 364:	4481                	li	s1,0
 366:	4aa9                	li	s5,10
 368:	4b35                	li	s6,13
 36a:	89a6                	mv	s3,s1
 36c:	2485                	addiw	s1,s1,1
 36e:	0344d663          	bge	s1,s4,39a <gets+0x52>
 372:	4605                	li	a2,1
 374:	faf40593          	addi	a1,s0,-81
 378:	4501                	li	a0,0
 37a:	186000ef          	jal	500 <read>
 37e:	00a05e63          	blez	a0,39a <gets+0x52>
 382:	faf44783          	lbu	a5,-81(s0)
 386:	00f90023          	sb	a5,0(s2)
 38a:	01578763          	beq	a5,s5,398 <gets+0x50>
 38e:	0905                	addi	s2,s2,1
 390:	fd679de3          	bne	a5,s6,36a <gets+0x22>
 394:	89a6                	mv	s3,s1
 396:	a011                	j	39a <gets+0x52>
 398:	89a6                	mv	s3,s1
 39a:	99de                	add	s3,s3,s7
 39c:	00098023          	sb	zero,0(s3)
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
 3b8:	1101                	addi	sp,sp,-32
 3ba:	ec06                	sd	ra,24(sp)
 3bc:	e822                	sd	s0,16(sp)
 3be:	e04a                	sd	s2,0(sp)
 3c0:	1000                	addi	s0,sp,32
 3c2:	892e                	mv	s2,a1
 3c4:	4581                	li	a1,0
 3c6:	162000ef          	jal	528 <open>
 3ca:	02054263          	bltz	a0,3ee <stat+0x36>
 3ce:	e426                	sd	s1,8(sp)
 3d0:	84aa                	mv	s1,a0
 3d2:	85ca                	mv	a1,s2
 3d4:	16c000ef          	jal	540 <fstat>
 3d8:	892a                	mv	s2,a0
 3da:	8526                	mv	a0,s1
 3dc:	134000ef          	jal	510 <close>
 3e0:	64a2                	ld	s1,8(sp)
 3e2:	854a                	mv	a0,s2
 3e4:	60e2                	ld	ra,24(sp)
 3e6:	6442                	ld	s0,16(sp)
 3e8:	6902                	ld	s2,0(sp)
 3ea:	6105                	addi	sp,sp,32
 3ec:	8082                	ret
 3ee:	597d                	li	s2,-1
 3f0:	bfcd                	j	3e2 <stat+0x2a>

00000000000003f2 <atoi>:
 3f2:	1141                	addi	sp,sp,-16
 3f4:	e422                	sd	s0,8(sp)
 3f6:	0800                	addi	s0,sp,16
 3f8:	00054683          	lbu	a3,0(a0)
 3fc:	fd06879b          	addiw	a5,a3,-48
 400:	0ff7f793          	zext.b	a5,a5
 404:	4625                	li	a2,9
 406:	02f66863          	bltu	a2,a5,436 <atoi+0x44>
 40a:	872a                	mv	a4,a0
 40c:	4501                	li	a0,0
 40e:	0705                	addi	a4,a4,1
 410:	0025179b          	slliw	a5,a0,0x2
 414:	9fa9                	addw	a5,a5,a0
 416:	0017979b          	slliw	a5,a5,0x1
 41a:	9fb5                	addw	a5,a5,a3
 41c:	fd07851b          	addiw	a0,a5,-48
 420:	00074683          	lbu	a3,0(a4)
 424:	fd06879b          	addiw	a5,a3,-48
 428:	0ff7f793          	zext.b	a5,a5
 42c:	fef671e3          	bgeu	a2,a5,40e <atoi+0x1c>
 430:	6422                	ld	s0,8(sp)
 432:	0141                	addi	sp,sp,16
 434:	8082                	ret
 436:	4501                	li	a0,0
 438:	bfe5                	j	430 <atoi+0x3e>

000000000000043a <memmove>:
 43a:	1141                	addi	sp,sp,-16
 43c:	e422                	sd	s0,8(sp)
 43e:	0800                	addi	s0,sp,16
 440:	02b57463          	bgeu	a0,a1,468 <memmove+0x2e>
 444:	00c05f63          	blez	a2,462 <memmove+0x28>
 448:	1602                	slli	a2,a2,0x20
 44a:	9201                	srli	a2,a2,0x20
 44c:	00c507b3          	add	a5,a0,a2
 450:	872a                	mv	a4,a0
 452:	0585                	addi	a1,a1,1
 454:	0705                	addi	a4,a4,1
 456:	fff5c683          	lbu	a3,-1(a1)
 45a:	fed70fa3          	sb	a3,-1(a4)
 45e:	fef71ae3          	bne	a4,a5,452 <memmove+0x18>
 462:	6422                	ld	s0,8(sp)
 464:	0141                	addi	sp,sp,16
 466:	8082                	ret
 468:	00c50733          	add	a4,a0,a2
 46c:	95b2                	add	a1,a1,a2
 46e:	fec05ae3          	blez	a2,462 <memmove+0x28>
 472:	fff6079b          	addiw	a5,a2,-1
 476:	1782                	slli	a5,a5,0x20
 478:	9381                	srli	a5,a5,0x20
 47a:	fff7c793          	not	a5,a5
 47e:	97ba                	add	a5,a5,a4
 480:	15fd                	addi	a1,a1,-1
 482:	177d                	addi	a4,a4,-1
 484:	0005c683          	lbu	a3,0(a1)
 488:	00d70023          	sb	a3,0(a4)
 48c:	fee79ae3          	bne	a5,a4,480 <memmove+0x46>
 490:	bfc9                	j	462 <memmove+0x28>

0000000000000492 <memcmp>:
 492:	1141                	addi	sp,sp,-16
 494:	e422                	sd	s0,8(sp)
 496:	0800                	addi	s0,sp,16
 498:	ca05                	beqz	a2,4c8 <memcmp+0x36>
 49a:	fff6069b          	addiw	a3,a2,-1
 49e:	1682                	slli	a3,a3,0x20
 4a0:	9281                	srli	a3,a3,0x20
 4a2:	0685                	addi	a3,a3,1
 4a4:	96aa                	add	a3,a3,a0
 4a6:	00054783          	lbu	a5,0(a0)
 4aa:	0005c703          	lbu	a4,0(a1)
 4ae:	00e79863          	bne	a5,a4,4be <memcmp+0x2c>
 4b2:	0505                	addi	a0,a0,1
 4b4:	0585                	addi	a1,a1,1
 4b6:	fed518e3          	bne	a0,a3,4a6 <memcmp+0x14>
 4ba:	4501                	li	a0,0
 4bc:	a019                	j	4c2 <memcmp+0x30>
 4be:	40e7853b          	subw	a0,a5,a4
 4c2:	6422                	ld	s0,8(sp)
 4c4:	0141                	addi	sp,sp,16
 4c6:	8082                	ret
 4c8:	4501                	li	a0,0
 4ca:	bfe5                	j	4c2 <memcmp+0x30>

00000000000004cc <memcpy>:
 4cc:	1141                	addi	sp,sp,-16
 4ce:	e406                	sd	ra,8(sp)
 4d0:	e022                	sd	s0,0(sp)
 4d2:	0800                	addi	s0,sp,16
 4d4:	f67ff0ef          	jal	43a <memmove>
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

00000000000005a8 <rand>:
.global rand
rand:
 li a7, SYS_rand
 5a8:	48ed                	li	a7,27
 ecall
 5aa:	00000073          	ecall
 ret
 5ae:	8082                	ret

00000000000005b0 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 5b0:	1101                	addi	sp,sp,-32
 5b2:	ec06                	sd	ra,24(sp)
 5b4:	e822                	sd	s0,16(sp)
 5b6:	1000                	addi	s0,sp,32
 5b8:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 5bc:	4605                	li	a2,1
 5be:	fef40593          	addi	a1,s0,-17
 5c2:	f47ff0ef          	jal	508 <write>
}
 5c6:	60e2                	ld	ra,24(sp)
 5c8:	6442                	ld	s0,16(sp)
 5ca:	6105                	addi	sp,sp,32
 5cc:	8082                	ret

00000000000005ce <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 5ce:	7139                	addi	sp,sp,-64
 5d0:	fc06                	sd	ra,56(sp)
 5d2:	f822                	sd	s0,48(sp)
 5d4:	f426                	sd	s1,40(sp)
 5d6:	0080                	addi	s0,sp,64
 5d8:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 5da:	c299                	beqz	a3,5e0 <printint+0x12>
 5dc:	0805c963          	bltz	a1,66e <printint+0xa0>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 5e0:	2581                	sext.w	a1,a1
  neg = 0;
 5e2:	4881                	li	a7,0
 5e4:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 5e8:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 5ea:	2601                	sext.w	a2,a2
 5ec:	00000517          	auipc	a0,0x0
 5f0:	59450513          	addi	a0,a0,1428 # b80 <digits>
 5f4:	883a                	mv	a6,a4
 5f6:	2705                	addiw	a4,a4,1
 5f8:	02c5f7bb          	remuw	a5,a1,a2
 5fc:	1782                	slli	a5,a5,0x20
 5fe:	9381                	srli	a5,a5,0x20
 600:	97aa                	add	a5,a5,a0
 602:	0007c783          	lbu	a5,0(a5)
 606:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 60a:	0005879b          	sext.w	a5,a1
 60e:	02c5d5bb          	divuw	a1,a1,a2
 612:	0685                	addi	a3,a3,1
 614:	fec7f0e3          	bgeu	a5,a2,5f4 <printint+0x26>
  if(neg)
 618:	00088c63          	beqz	a7,630 <printint+0x62>
    buf[i++] = '-';
 61c:	fd070793          	addi	a5,a4,-48
 620:	00878733          	add	a4,a5,s0
 624:	02d00793          	li	a5,45
 628:	fef70823          	sb	a5,-16(a4)
 62c:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 630:	02e05a63          	blez	a4,664 <printint+0x96>
 634:	f04a                	sd	s2,32(sp)
 636:	ec4e                	sd	s3,24(sp)
 638:	fc040793          	addi	a5,s0,-64
 63c:	00e78933          	add	s2,a5,a4
 640:	fff78993          	addi	s3,a5,-1
 644:	99ba                	add	s3,s3,a4
 646:	377d                	addiw	a4,a4,-1
 648:	1702                	slli	a4,a4,0x20
 64a:	9301                	srli	a4,a4,0x20
 64c:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 650:	fff94583          	lbu	a1,-1(s2)
 654:	8526                	mv	a0,s1
 656:	f5bff0ef          	jal	5b0 <putc>
  while(--i >= 0)
 65a:	197d                	addi	s2,s2,-1
 65c:	ff391ae3          	bne	s2,s3,650 <printint+0x82>
 660:	7902                	ld	s2,32(sp)
 662:	69e2                	ld	s3,24(sp)
}
 664:	70e2                	ld	ra,56(sp)
 666:	7442                	ld	s0,48(sp)
 668:	74a2                	ld	s1,40(sp)
 66a:	6121                	addi	sp,sp,64
 66c:	8082                	ret
    x = -xx;
 66e:	40b005bb          	negw	a1,a1
    neg = 1;
 672:	4885                	li	a7,1
    x = -xx;
 674:	bf85                	j	5e4 <printint+0x16>

0000000000000676 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 676:	711d                	addi	sp,sp,-96
 678:	ec86                	sd	ra,88(sp)
 67a:	e8a2                	sd	s0,80(sp)
 67c:	e0ca                	sd	s2,64(sp)
 67e:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 680:	0005c903          	lbu	s2,0(a1)
 684:	26090863          	beqz	s2,8f4 <vprintf+0x27e>
 688:	e4a6                	sd	s1,72(sp)
 68a:	fc4e                	sd	s3,56(sp)
 68c:	f852                	sd	s4,48(sp)
 68e:	f456                	sd	s5,40(sp)
 690:	f05a                	sd	s6,32(sp)
 692:	ec5e                	sd	s7,24(sp)
 694:	e862                	sd	s8,16(sp)
 696:	e466                	sd	s9,8(sp)
 698:	8b2a                	mv	s6,a0
 69a:	8a2e                	mv	s4,a1
 69c:	8bb2                	mv	s7,a2
  state = 0;
 69e:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 6a0:	4481                	li	s1,0
 6a2:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 6a4:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 6a8:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 6ac:	06c00c93          	li	s9,108
 6b0:	a005                	j	6d0 <vprintf+0x5a>
        putc(fd, c0);
 6b2:	85ca                	mv	a1,s2
 6b4:	855a                	mv	a0,s6
 6b6:	efbff0ef          	jal	5b0 <putc>
 6ba:	a019                	j	6c0 <vprintf+0x4a>
    } else if(state == '%'){
 6bc:	03598263          	beq	s3,s5,6e0 <vprintf+0x6a>
  for(i = 0; fmt[i]; i++){
 6c0:	2485                	addiw	s1,s1,1
 6c2:	8726                	mv	a4,s1
 6c4:	009a07b3          	add	a5,s4,s1
 6c8:	0007c903          	lbu	s2,0(a5)
 6cc:	20090c63          	beqz	s2,8e4 <vprintf+0x26e>
    c0 = fmt[i] & 0xff;
 6d0:	0009079b          	sext.w	a5,s2
    if(state == 0){
 6d4:	fe0994e3          	bnez	s3,6bc <vprintf+0x46>
      if(c0 == '%'){
 6d8:	fd579de3          	bne	a5,s5,6b2 <vprintf+0x3c>
        state = '%';
 6dc:	89be                	mv	s3,a5
 6de:	b7cd                	j	6c0 <vprintf+0x4a>
      if(c0) c1 = fmt[i+1] & 0xff;
 6e0:	00ea06b3          	add	a3,s4,a4
 6e4:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 6e8:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
 6ea:	c681                	beqz	a3,6f2 <vprintf+0x7c>
 6ec:	9752                	add	a4,a4,s4
 6ee:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
 6f2:	03878f63          	beq	a5,s8,730 <vprintf+0xba>
      } else if(c0 == 'l' && c1 == 'd'){
 6f6:	05978963          	beq	a5,s9,748 <vprintf+0xd2>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
 6fa:	07500713          	li	a4,117
 6fe:	0ee78363          	beq	a5,a4,7e4 <vprintf+0x16e>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
 702:	07800713          	li	a4,120
 706:	12e78563          	beq	a5,a4,830 <vprintf+0x1ba>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
 70a:	07000713          	li	a4,112
 70e:	14e78a63          	beq	a5,a4,862 <vprintf+0x1ec>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 's'){
 712:	07300713          	li	a4,115
 716:	18e78a63          	beq	a5,a4,8aa <vprintf+0x234>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
 71a:	02500713          	li	a4,37
 71e:	04e79563          	bne	a5,a4,768 <vprintf+0xf2>
        putc(fd, '%');
 722:	02500593          	li	a1,37
 726:	855a                	mv	a0,s6
 728:	e89ff0ef          	jal	5b0 <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
#endif
      state = 0;
 72c:	4981                	li	s3,0
 72e:	bf49                	j	6c0 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 1);
 730:	008b8913          	addi	s2,s7,8
 734:	4685                	li	a3,1
 736:	4629                	li	a2,10
 738:	000ba583          	lw	a1,0(s7)
 73c:	855a                	mv	a0,s6
 73e:	e91ff0ef          	jal	5ce <printint>
 742:	8bca                	mv	s7,s2
      state = 0;
 744:	4981                	li	s3,0
 746:	bfad                	j	6c0 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'd'){
 748:	06400793          	li	a5,100
 74c:	02f68963          	beq	a3,a5,77e <vprintf+0x108>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 750:	06c00793          	li	a5,108
 754:	04f68263          	beq	a3,a5,798 <vprintf+0x122>
      } else if(c0 == 'l' && c1 == 'u'){
 758:	07500793          	li	a5,117
 75c:	0af68063          	beq	a3,a5,7fc <vprintf+0x186>
      } else if(c0 == 'l' && c1 == 'x'){
 760:	07800793          	li	a5,120
 764:	0ef68263          	beq	a3,a5,848 <vprintf+0x1d2>
        putc(fd, '%');
 768:	02500593          	li	a1,37
 76c:	855a                	mv	a0,s6
 76e:	e43ff0ef          	jal	5b0 <putc>
        putc(fd, c0);
 772:	85ca                	mv	a1,s2
 774:	855a                	mv	a0,s6
 776:	e3bff0ef          	jal	5b0 <putc>
      state = 0;
 77a:	4981                	li	s3,0
 77c:	b791                	j	6c0 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 77e:	008b8913          	addi	s2,s7,8
 782:	4685                	li	a3,1
 784:	4629                	li	a2,10
 786:	000ba583          	lw	a1,0(s7)
 78a:	855a                	mv	a0,s6
 78c:	e43ff0ef          	jal	5ce <printint>
        i += 1;
 790:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 792:	8bca                	mv	s7,s2
      state = 0;
 794:	4981                	li	s3,0
        i += 1;
 796:	b72d                	j	6c0 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 798:	06400793          	li	a5,100
 79c:	02f60763          	beq	a2,a5,7ca <vprintf+0x154>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 7a0:	07500793          	li	a5,117
 7a4:	06f60963          	beq	a2,a5,816 <vprintf+0x1a0>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 7a8:	07800793          	li	a5,120
 7ac:	faf61ee3          	bne	a2,a5,768 <vprintf+0xf2>
        printint(fd, va_arg(ap, uint64), 16, 0);
 7b0:	008b8913          	addi	s2,s7,8
 7b4:	4681                	li	a3,0
 7b6:	4641                	li	a2,16
 7b8:	000ba583          	lw	a1,0(s7)
 7bc:	855a                	mv	a0,s6
 7be:	e11ff0ef          	jal	5ce <printint>
        i += 2;
 7c2:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 7c4:	8bca                	mv	s7,s2
      state = 0;
 7c6:	4981                	li	s3,0
        i += 2;
 7c8:	bde5                	j	6c0 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 7ca:	008b8913          	addi	s2,s7,8
 7ce:	4685                	li	a3,1
 7d0:	4629                	li	a2,10
 7d2:	000ba583          	lw	a1,0(s7)
 7d6:	855a                	mv	a0,s6
 7d8:	df7ff0ef          	jal	5ce <printint>
        i += 2;
 7dc:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 7de:	8bca                	mv	s7,s2
      state = 0;
 7e0:	4981                	li	s3,0
        i += 2;
 7e2:	bdf9                	j	6c0 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 0);
 7e4:	008b8913          	addi	s2,s7,8
 7e8:	4681                	li	a3,0
 7ea:	4629                	li	a2,10
 7ec:	000ba583          	lw	a1,0(s7)
 7f0:	855a                	mv	a0,s6
 7f2:	dddff0ef          	jal	5ce <printint>
 7f6:	8bca                	mv	s7,s2
      state = 0;
 7f8:	4981                	li	s3,0
 7fa:	b5d9                	j	6c0 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 7fc:	008b8913          	addi	s2,s7,8
 800:	4681                	li	a3,0
 802:	4629                	li	a2,10
 804:	000ba583          	lw	a1,0(s7)
 808:	855a                	mv	a0,s6
 80a:	dc5ff0ef          	jal	5ce <printint>
        i += 1;
 80e:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 810:	8bca                	mv	s7,s2
      state = 0;
 812:	4981                	li	s3,0
        i += 1;
 814:	b575                	j	6c0 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 816:	008b8913          	addi	s2,s7,8
 81a:	4681                	li	a3,0
 81c:	4629                	li	a2,10
 81e:	000ba583          	lw	a1,0(s7)
 822:	855a                	mv	a0,s6
 824:	dabff0ef          	jal	5ce <printint>
        i += 2;
 828:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 82a:	8bca                	mv	s7,s2
      state = 0;
 82c:	4981                	li	s3,0
        i += 2;
 82e:	bd49                	j	6c0 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 16, 0);
 830:	008b8913          	addi	s2,s7,8
 834:	4681                	li	a3,0
 836:	4641                	li	a2,16
 838:	000ba583          	lw	a1,0(s7)
 83c:	855a                	mv	a0,s6
 83e:	d91ff0ef          	jal	5ce <printint>
 842:	8bca                	mv	s7,s2
      state = 0;
 844:	4981                	li	s3,0
 846:	bdad                	j	6c0 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 16, 0);
 848:	008b8913          	addi	s2,s7,8
 84c:	4681                	li	a3,0
 84e:	4641                	li	a2,16
 850:	000ba583          	lw	a1,0(s7)
 854:	855a                	mv	a0,s6
 856:	d79ff0ef          	jal	5ce <printint>
        i += 1;
 85a:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 85c:	8bca                	mv	s7,s2
      state = 0;
 85e:	4981                	li	s3,0
        i += 1;
 860:	b585                	j	6c0 <vprintf+0x4a>
 862:	e06a                	sd	s10,0(sp)
        printptr(fd, va_arg(ap, uint64));
 864:	008b8d13          	addi	s10,s7,8
 868:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 86c:	03000593          	li	a1,48
 870:	855a                	mv	a0,s6
 872:	d3fff0ef          	jal	5b0 <putc>
  putc(fd, 'x');
 876:	07800593          	li	a1,120
 87a:	855a                	mv	a0,s6
 87c:	d35ff0ef          	jal	5b0 <putc>
 880:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 882:	00000b97          	auipc	s7,0x0
 886:	2feb8b93          	addi	s7,s7,766 # b80 <digits>
 88a:	03c9d793          	srli	a5,s3,0x3c
 88e:	97de                	add	a5,a5,s7
 890:	0007c583          	lbu	a1,0(a5)
 894:	855a                	mv	a0,s6
 896:	d1bff0ef          	jal	5b0 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 89a:	0992                	slli	s3,s3,0x4
 89c:	397d                	addiw	s2,s2,-1
 89e:	fe0916e3          	bnez	s2,88a <vprintf+0x214>
        printptr(fd, va_arg(ap, uint64));
 8a2:	8bea                	mv	s7,s10
      state = 0;
 8a4:	4981                	li	s3,0
 8a6:	6d02                	ld	s10,0(sp)
 8a8:	bd21                	j	6c0 <vprintf+0x4a>
        if((s = va_arg(ap, char*)) == 0)
 8aa:	008b8993          	addi	s3,s7,8
 8ae:	000bb903          	ld	s2,0(s7)
 8b2:	00090f63          	beqz	s2,8d0 <vprintf+0x25a>
        for(; *s; s++)
 8b6:	00094583          	lbu	a1,0(s2)
 8ba:	c195                	beqz	a1,8de <vprintf+0x268>
          putc(fd, *s);
 8bc:	855a                	mv	a0,s6
 8be:	cf3ff0ef          	jal	5b0 <putc>
        for(; *s; s++)
 8c2:	0905                	addi	s2,s2,1
 8c4:	00094583          	lbu	a1,0(s2)
 8c8:	f9f5                	bnez	a1,8bc <vprintf+0x246>
        if((s = va_arg(ap, char*)) == 0)
 8ca:	8bce                	mv	s7,s3
      state = 0;
 8cc:	4981                	li	s3,0
 8ce:	bbcd                	j	6c0 <vprintf+0x4a>
          s = "(null)";
 8d0:	00000917          	auipc	s2,0x0
 8d4:	2a890913          	addi	s2,s2,680 # b78 <malloc+0x19c>
        for(; *s; s++)
 8d8:	02800593          	li	a1,40
 8dc:	b7c5                	j	8bc <vprintf+0x246>
        if((s = va_arg(ap, char*)) == 0)
 8de:	8bce                	mv	s7,s3
      state = 0;
 8e0:	4981                	li	s3,0
 8e2:	bbf9                	j	6c0 <vprintf+0x4a>
 8e4:	64a6                	ld	s1,72(sp)
 8e6:	79e2                	ld	s3,56(sp)
 8e8:	7a42                	ld	s4,48(sp)
 8ea:	7aa2                	ld	s5,40(sp)
 8ec:	7b02                	ld	s6,32(sp)
 8ee:	6be2                	ld	s7,24(sp)
 8f0:	6c42                	ld	s8,16(sp)
 8f2:	6ca2                	ld	s9,8(sp)
    }
  }
}
 8f4:	60e6                	ld	ra,88(sp)
 8f6:	6446                	ld	s0,80(sp)
 8f8:	6906                	ld	s2,64(sp)
 8fa:	6125                	addi	sp,sp,96
 8fc:	8082                	ret

00000000000008fe <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 8fe:	715d                	addi	sp,sp,-80
 900:	ec06                	sd	ra,24(sp)
 902:	e822                	sd	s0,16(sp)
 904:	1000                	addi	s0,sp,32
 906:	e010                	sd	a2,0(s0)
 908:	e414                	sd	a3,8(s0)
 90a:	e818                	sd	a4,16(s0)
 90c:	ec1c                	sd	a5,24(s0)
 90e:	03043023          	sd	a6,32(s0)
 912:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 916:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 91a:	8622                	mv	a2,s0
 91c:	d5bff0ef          	jal	676 <vprintf>
}
 920:	60e2                	ld	ra,24(sp)
 922:	6442                	ld	s0,16(sp)
 924:	6161                	addi	sp,sp,80
 926:	8082                	ret

0000000000000928 <printf>:

void
printf(const char *fmt, ...)
{
 928:	711d                	addi	sp,sp,-96
 92a:	ec06                	sd	ra,24(sp)
 92c:	e822                	sd	s0,16(sp)
 92e:	1000                	addi	s0,sp,32
 930:	e40c                	sd	a1,8(s0)
 932:	e810                	sd	a2,16(s0)
 934:	ec14                	sd	a3,24(s0)
 936:	f018                	sd	a4,32(s0)
 938:	f41c                	sd	a5,40(s0)
 93a:	03043823          	sd	a6,48(s0)
 93e:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 942:	00840613          	addi	a2,s0,8
 946:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 94a:	85aa                	mv	a1,a0
 94c:	4505                	li	a0,1
 94e:	d29ff0ef          	jal	676 <vprintf>
}
 952:	60e2                	ld	ra,24(sp)
 954:	6442                	ld	s0,16(sp)
 956:	6125                	addi	sp,sp,96
 958:	8082                	ret

000000000000095a <free>:
 95a:	1141                	addi	sp,sp,-16
 95c:	e422                	sd	s0,8(sp)
 95e:	0800                	addi	s0,sp,16
 960:	ff050693          	addi	a3,a0,-16
 964:	00001797          	auipc	a5,0x1
 968:	69c7b783          	ld	a5,1692(a5) # 2000 <freep>
 96c:	a02d                	j	996 <free+0x3c>
 96e:	4618                	lw	a4,8(a2)
 970:	9f2d                	addw	a4,a4,a1
 972:	fee52c23          	sw	a4,-8(a0)
 976:	6398                	ld	a4,0(a5)
 978:	6310                	ld	a2,0(a4)
 97a:	a83d                	j	9b8 <free+0x5e>
 97c:	ff852703          	lw	a4,-8(a0)
 980:	9f31                	addw	a4,a4,a2
 982:	c798                	sw	a4,8(a5)
 984:	ff053683          	ld	a3,-16(a0)
 988:	a091                	j	9cc <free+0x72>
 98a:	6398                	ld	a4,0(a5)
 98c:	00e7e463          	bltu	a5,a4,994 <free+0x3a>
 990:	00e6ea63          	bltu	a3,a4,9a4 <free+0x4a>
 994:	87ba                	mv	a5,a4
 996:	fed7fae3          	bgeu	a5,a3,98a <free+0x30>
 99a:	6398                	ld	a4,0(a5)
 99c:	00e6e463          	bltu	a3,a4,9a4 <free+0x4a>
 9a0:	fee7eae3          	bltu	a5,a4,994 <free+0x3a>
 9a4:	ff852583          	lw	a1,-8(a0)
 9a8:	6390                	ld	a2,0(a5)
 9aa:	02059813          	slli	a6,a1,0x20
 9ae:	01c85713          	srli	a4,a6,0x1c
 9b2:	9736                	add	a4,a4,a3
 9b4:	fae60de3          	beq	a2,a4,96e <free+0x14>
 9b8:	fec53823          	sd	a2,-16(a0)
 9bc:	4790                	lw	a2,8(a5)
 9be:	02061593          	slli	a1,a2,0x20
 9c2:	01c5d713          	srli	a4,a1,0x1c
 9c6:	973e                	add	a4,a4,a5
 9c8:	fae68ae3          	beq	a3,a4,97c <free+0x22>
 9cc:	e394                	sd	a3,0(a5)
 9ce:	00001717          	auipc	a4,0x1
 9d2:	62f73923          	sd	a5,1586(a4) # 2000 <freep>
 9d6:	6422                	ld	s0,8(sp)
 9d8:	0141                	addi	sp,sp,16
 9da:	8082                	ret

00000000000009dc <malloc>:
 9dc:	7139                	addi	sp,sp,-64
 9de:	fc06                	sd	ra,56(sp)
 9e0:	f822                	sd	s0,48(sp)
 9e2:	f426                	sd	s1,40(sp)
 9e4:	ec4e                	sd	s3,24(sp)
 9e6:	0080                	addi	s0,sp,64
 9e8:	02051493          	slli	s1,a0,0x20
 9ec:	9081                	srli	s1,s1,0x20
 9ee:	04bd                	addi	s1,s1,15
 9f0:	8091                	srli	s1,s1,0x4
 9f2:	0014899b          	addiw	s3,s1,1
 9f6:	0485                	addi	s1,s1,1
 9f8:	00001517          	auipc	a0,0x1
 9fc:	60853503          	ld	a0,1544(a0) # 2000 <freep>
 a00:	c915                	beqz	a0,a34 <malloc+0x58>
 a02:	611c                	ld	a5,0(a0)
 a04:	4798                	lw	a4,8(a5)
 a06:	08977a63          	bgeu	a4,s1,a9a <malloc+0xbe>
 a0a:	f04a                	sd	s2,32(sp)
 a0c:	e852                	sd	s4,16(sp)
 a0e:	e456                	sd	s5,8(sp)
 a10:	e05a                	sd	s6,0(sp)
 a12:	8a4e                	mv	s4,s3
 a14:	0009871b          	sext.w	a4,s3
 a18:	6685                	lui	a3,0x1
 a1a:	00d77363          	bgeu	a4,a3,a20 <malloc+0x44>
 a1e:	6a05                	lui	s4,0x1
 a20:	000a0b1b          	sext.w	s6,s4
 a24:	004a1a1b          	slliw	s4,s4,0x4
 a28:	00001917          	auipc	s2,0x1
 a2c:	5d890913          	addi	s2,s2,1496 # 2000 <freep>
 a30:	5afd                	li	s5,-1
 a32:	a081                	j	a72 <malloc+0x96>
 a34:	f04a                	sd	s2,32(sp)
 a36:	e852                	sd	s4,16(sp)
 a38:	e456                	sd	s5,8(sp)
 a3a:	e05a                	sd	s6,0(sp)
 a3c:	00001797          	auipc	a5,0x1
 a40:	5d478793          	addi	a5,a5,1492 # 2010 <base>
 a44:	00001717          	auipc	a4,0x1
 a48:	5af73e23          	sd	a5,1468(a4) # 2000 <freep>
 a4c:	e39c                	sd	a5,0(a5)
 a4e:	0007a423          	sw	zero,8(a5)
 a52:	b7c1                	j	a12 <malloc+0x36>
 a54:	6398                	ld	a4,0(a5)
 a56:	e118                	sd	a4,0(a0)
 a58:	a8a9                	j	ab2 <malloc+0xd6>
 a5a:	01652423          	sw	s6,8(a0)
 a5e:	0541                	addi	a0,a0,16
 a60:	efbff0ef          	jal	95a <free>
 a64:	00093503          	ld	a0,0(s2)
 a68:	c12d                	beqz	a0,aca <malloc+0xee>
 a6a:	611c                	ld	a5,0(a0)
 a6c:	4798                	lw	a4,8(a5)
 a6e:	02977263          	bgeu	a4,s1,a92 <malloc+0xb6>
 a72:	00093703          	ld	a4,0(s2)
 a76:	853e                	mv	a0,a5
 a78:	fef719e3          	bne	a4,a5,a6a <malloc+0x8e>
 a7c:	8552                	mv	a0,s4
 a7e:	af3ff0ef          	jal	570 <sbrk>
 a82:	fd551ce3          	bne	a0,s5,a5a <malloc+0x7e>
 a86:	4501                	li	a0,0
 a88:	7902                	ld	s2,32(sp)
 a8a:	6a42                	ld	s4,16(sp)
 a8c:	6aa2                	ld	s5,8(sp)
 a8e:	6b02                	ld	s6,0(sp)
 a90:	a03d                	j	abe <malloc+0xe2>
 a92:	7902                	ld	s2,32(sp)
 a94:	6a42                	ld	s4,16(sp)
 a96:	6aa2                	ld	s5,8(sp)
 a98:	6b02                	ld	s6,0(sp)
 a9a:	fae48de3          	beq	s1,a4,a54 <malloc+0x78>
 a9e:	4137073b          	subw	a4,a4,s3
 aa2:	c798                	sw	a4,8(a5)
 aa4:	02071693          	slli	a3,a4,0x20
 aa8:	01c6d713          	srli	a4,a3,0x1c
 aac:	97ba                	add	a5,a5,a4
 aae:	0137a423          	sw	s3,8(a5)
 ab2:	00001717          	auipc	a4,0x1
 ab6:	54a73723          	sd	a0,1358(a4) # 2000 <freep>
 aba:	01078513          	addi	a0,a5,16
 abe:	70e2                	ld	ra,56(sp)
 ac0:	7442                	ld	s0,48(sp)
 ac2:	74a2                	ld	s1,40(sp)
 ac4:	69e2                	ld	s3,24(sp)
 ac6:	6121                	addi	sp,sp,64
 ac8:	8082                	ret
 aca:	7902                	ld	s2,32(sp)
 acc:	6a42                	ld	s4,16(sp)
 ace:	6aa2                	ld	s5,8(sp)
 ad0:	6b02                	ld	s6,0(sp)
 ad2:	b7f5                	j	abe <malloc+0xe2>
