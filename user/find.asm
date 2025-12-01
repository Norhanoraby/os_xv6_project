
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
   c:	ab850513          	addi	a0,a0,-1352 # ac0 <malloc+0x104>
  10:	0f9000ef          	jal	908 <printf>
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
  a0:	a84b0b13          	addi	s6,s6,-1404 # b20 <malloc+0x164>
  a4:	00001b97          	auipc	s7,0x1
  a8:	a84b8b93          	addi	s7,s7,-1404 # b28 <malloc+0x16c>
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
 148:	9a450513          	addi	a0,a0,-1628 # ae8 <malloc+0x12c>
 14c:	7bc000ef          	jal	908 <printf>
        return 0;//cannot be opened(not found)
 150:	4a81                	li	s5,0
 152:	a845                	j	202 <find+0x1b4>
        printf("find: cannot stat %s\n", path);
 154:	85ca                	mv	a1,s2
 156:	00001517          	auipc	a0,0x1
 15a:	9aa50513          	addi	a0,a0,-1622 # b00 <malloc+0x144>
 15e:	7aa000ef          	jal	908 <printf>
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
 1b0:	96c50513          	addi	a0,a0,-1684 # b18 <malloc+0x15c>
 1b4:	754000ef          	jal	908 <printf>
            found = 1;
 1b8:	4a85                	li	s5,1
 1ba:	b7d5                	j	19e <find+0x150>
            printf("%s\n", buf);//print the full path
 1bc:	d8840593          	addi	a1,s0,-632
 1c0:	00001517          	auipc	a0,0x1
 1c4:	95850513          	addi	a0,a0,-1704 # b18 <malloc+0x15c>
 1c8:	740000ef          	jal	908 <printf>
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
 244:	8f058593          	addi	a1,a1,-1808 # b30 <malloc+0x174>
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
 26a:	8d250513          	addi	a0,a0,-1838 # b38 <malloc+0x17c>
 26e:	69a000ef          	jal	908 <printf>
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
 4e0:	4885                	li	a7,1
 4e2:	00000073          	ecall
 4e6:	8082                	ret

00000000000004e8 <exit>:
 4e8:	4889                	li	a7,2
 4ea:	00000073          	ecall
 4ee:	8082                	ret

00000000000004f0 <wait>:
 4f0:	488d                	li	a7,3
 4f2:	00000073          	ecall
 4f6:	8082                	ret

00000000000004f8 <pipe>:
 4f8:	4891                	li	a7,4
 4fa:	00000073          	ecall
 4fe:	8082                	ret

0000000000000500 <read>:
 500:	4895                	li	a7,5
 502:	00000073          	ecall
 506:	8082                	ret

0000000000000508 <write>:
 508:	48c1                	li	a7,16
 50a:	00000073          	ecall
 50e:	8082                	ret

0000000000000510 <close>:
 510:	48d5                	li	a7,21
 512:	00000073          	ecall
 516:	8082                	ret

0000000000000518 <kill>:
 518:	4899                	li	a7,6
 51a:	00000073          	ecall
 51e:	8082                	ret

0000000000000520 <exec>:
 520:	489d                	li	a7,7
 522:	00000073          	ecall
 526:	8082                	ret

0000000000000528 <open>:
 528:	48bd                	li	a7,15
 52a:	00000073          	ecall
 52e:	8082                	ret

0000000000000530 <mknod>:
 530:	48c5                	li	a7,17
 532:	00000073          	ecall
 536:	8082                	ret

0000000000000538 <unlink>:
 538:	48c9                	li	a7,18
 53a:	00000073          	ecall
 53e:	8082                	ret

0000000000000540 <fstat>:
 540:	48a1                	li	a7,8
 542:	00000073          	ecall
 546:	8082                	ret

0000000000000548 <link>:
 548:	48cd                	li	a7,19
 54a:	00000073          	ecall
 54e:	8082                	ret

0000000000000550 <mkdir>:
 550:	48d1                	li	a7,20
 552:	00000073          	ecall
 556:	8082                	ret

0000000000000558 <chdir>:
 558:	48a5                	li	a7,9
 55a:	00000073          	ecall
 55e:	8082                	ret

0000000000000560 <dup>:
 560:	48a9                	li	a7,10
 562:	00000073          	ecall
 566:	8082                	ret

0000000000000568 <getpid>:
 568:	48ad                	li	a7,11
 56a:	00000073          	ecall
 56e:	8082                	ret

0000000000000570 <sbrk>:
 570:	48b1                	li	a7,12
 572:	00000073          	ecall
 576:	8082                	ret

0000000000000578 <sleep>:
 578:	48b5                	li	a7,13
 57a:	00000073          	ecall
 57e:	8082                	ret

0000000000000580 <uptime>:
 580:	48b9                	li	a7,14
 582:	00000073          	ecall
 586:	8082                	ret

0000000000000588 <kbdint>:
 588:	48d9                	li	a7,22
 58a:	00000073          	ecall
 58e:	8082                	ret

0000000000000590 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 590:	1101                	addi	sp,sp,-32
 592:	ec06                	sd	ra,24(sp)
 594:	e822                	sd	s0,16(sp)
 596:	1000                	addi	s0,sp,32
 598:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 59c:	4605                	li	a2,1
 59e:	fef40593          	addi	a1,s0,-17
 5a2:	f67ff0ef          	jal	508 <write>
}
 5a6:	60e2                	ld	ra,24(sp)
 5a8:	6442                	ld	s0,16(sp)
 5aa:	6105                	addi	sp,sp,32
 5ac:	8082                	ret

00000000000005ae <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 5ae:	7139                	addi	sp,sp,-64
 5b0:	fc06                	sd	ra,56(sp)
 5b2:	f822                	sd	s0,48(sp)
 5b4:	f426                	sd	s1,40(sp)
 5b6:	0080                	addi	s0,sp,64
 5b8:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 5ba:	c299                	beqz	a3,5c0 <printint+0x12>
 5bc:	0805c963          	bltz	a1,64e <printint+0xa0>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 5c0:	2581                	sext.w	a1,a1
  neg = 0;
 5c2:	4881                	li	a7,0
 5c4:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 5c8:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 5ca:	2601                	sext.w	a2,a2
 5cc:	00000517          	auipc	a0,0x0
 5d0:	59450513          	addi	a0,a0,1428 # b60 <digits>
 5d4:	883a                	mv	a6,a4
 5d6:	2705                	addiw	a4,a4,1
 5d8:	02c5f7bb          	remuw	a5,a1,a2
 5dc:	1782                	slli	a5,a5,0x20
 5de:	9381                	srli	a5,a5,0x20
 5e0:	97aa                	add	a5,a5,a0
 5e2:	0007c783          	lbu	a5,0(a5)
 5e6:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 5ea:	0005879b          	sext.w	a5,a1
 5ee:	02c5d5bb          	divuw	a1,a1,a2
 5f2:	0685                	addi	a3,a3,1
 5f4:	fec7f0e3          	bgeu	a5,a2,5d4 <printint+0x26>
  if(neg)
 5f8:	00088c63          	beqz	a7,610 <printint+0x62>
    buf[i++] = '-';
 5fc:	fd070793          	addi	a5,a4,-48
 600:	00878733          	add	a4,a5,s0
 604:	02d00793          	li	a5,45
 608:	fef70823          	sb	a5,-16(a4)
 60c:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 610:	02e05a63          	blez	a4,644 <printint+0x96>
 614:	f04a                	sd	s2,32(sp)
 616:	ec4e                	sd	s3,24(sp)
 618:	fc040793          	addi	a5,s0,-64
 61c:	00e78933          	add	s2,a5,a4
 620:	fff78993          	addi	s3,a5,-1
 624:	99ba                	add	s3,s3,a4
 626:	377d                	addiw	a4,a4,-1
 628:	1702                	slli	a4,a4,0x20
 62a:	9301                	srli	a4,a4,0x20
 62c:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 630:	fff94583          	lbu	a1,-1(s2)
 634:	8526                	mv	a0,s1
 636:	f5bff0ef          	jal	590 <putc>
  while(--i >= 0)
 63a:	197d                	addi	s2,s2,-1
 63c:	ff391ae3          	bne	s2,s3,630 <printint+0x82>
 640:	7902                	ld	s2,32(sp)
 642:	69e2                	ld	s3,24(sp)
}
 644:	70e2                	ld	ra,56(sp)
 646:	7442                	ld	s0,48(sp)
 648:	74a2                	ld	s1,40(sp)
 64a:	6121                	addi	sp,sp,64
 64c:	8082                	ret
    x = -xx;
 64e:	40b005bb          	negw	a1,a1
    neg = 1;
 652:	4885                	li	a7,1
    x = -xx;
 654:	bf85                	j	5c4 <printint+0x16>

0000000000000656 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 656:	711d                	addi	sp,sp,-96
 658:	ec86                	sd	ra,88(sp)
 65a:	e8a2                	sd	s0,80(sp)
 65c:	e0ca                	sd	s2,64(sp)
 65e:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 660:	0005c903          	lbu	s2,0(a1)
 664:	26090863          	beqz	s2,8d4 <vprintf+0x27e>
 668:	e4a6                	sd	s1,72(sp)
 66a:	fc4e                	sd	s3,56(sp)
 66c:	f852                	sd	s4,48(sp)
 66e:	f456                	sd	s5,40(sp)
 670:	f05a                	sd	s6,32(sp)
 672:	ec5e                	sd	s7,24(sp)
 674:	e862                	sd	s8,16(sp)
 676:	e466                	sd	s9,8(sp)
 678:	8b2a                	mv	s6,a0
 67a:	8a2e                	mv	s4,a1
 67c:	8bb2                	mv	s7,a2
  state = 0;
 67e:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 680:	4481                	li	s1,0
 682:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 684:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 688:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 68c:	06c00c93          	li	s9,108
 690:	a005                	j	6b0 <vprintf+0x5a>
        putc(fd, c0);
 692:	85ca                	mv	a1,s2
 694:	855a                	mv	a0,s6
 696:	efbff0ef          	jal	590 <putc>
 69a:	a019                	j	6a0 <vprintf+0x4a>
    } else if(state == '%'){
 69c:	03598263          	beq	s3,s5,6c0 <vprintf+0x6a>
  for(i = 0; fmt[i]; i++){
 6a0:	2485                	addiw	s1,s1,1
 6a2:	8726                	mv	a4,s1
 6a4:	009a07b3          	add	a5,s4,s1
 6a8:	0007c903          	lbu	s2,0(a5)
 6ac:	20090c63          	beqz	s2,8c4 <vprintf+0x26e>
    c0 = fmt[i] & 0xff;
 6b0:	0009079b          	sext.w	a5,s2
    if(state == 0){
 6b4:	fe0994e3          	bnez	s3,69c <vprintf+0x46>
      if(c0 == '%'){
 6b8:	fd579de3          	bne	a5,s5,692 <vprintf+0x3c>
        state = '%';
 6bc:	89be                	mv	s3,a5
 6be:	b7cd                	j	6a0 <vprintf+0x4a>
      if(c0) c1 = fmt[i+1] & 0xff;
 6c0:	00ea06b3          	add	a3,s4,a4
 6c4:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 6c8:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
 6ca:	c681                	beqz	a3,6d2 <vprintf+0x7c>
 6cc:	9752                	add	a4,a4,s4
 6ce:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
 6d2:	03878f63          	beq	a5,s8,710 <vprintf+0xba>
      } else if(c0 == 'l' && c1 == 'd'){
 6d6:	05978963          	beq	a5,s9,728 <vprintf+0xd2>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
 6da:	07500713          	li	a4,117
 6de:	0ee78363          	beq	a5,a4,7c4 <vprintf+0x16e>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
 6e2:	07800713          	li	a4,120
 6e6:	12e78563          	beq	a5,a4,810 <vprintf+0x1ba>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
 6ea:	07000713          	li	a4,112
 6ee:	14e78a63          	beq	a5,a4,842 <vprintf+0x1ec>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 's'){
 6f2:	07300713          	li	a4,115
 6f6:	18e78a63          	beq	a5,a4,88a <vprintf+0x234>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
 6fa:	02500713          	li	a4,37
 6fe:	04e79563          	bne	a5,a4,748 <vprintf+0xf2>
        putc(fd, '%');
 702:	02500593          	li	a1,37
 706:	855a                	mv	a0,s6
 708:	e89ff0ef          	jal	590 <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
#endif
      state = 0;
 70c:	4981                	li	s3,0
 70e:	bf49                	j	6a0 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 1);
 710:	008b8913          	addi	s2,s7,8
 714:	4685                	li	a3,1
 716:	4629                	li	a2,10
 718:	000ba583          	lw	a1,0(s7)
 71c:	855a                	mv	a0,s6
 71e:	e91ff0ef          	jal	5ae <printint>
 722:	8bca                	mv	s7,s2
      state = 0;
 724:	4981                	li	s3,0
 726:	bfad                	j	6a0 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'd'){
 728:	06400793          	li	a5,100
 72c:	02f68963          	beq	a3,a5,75e <vprintf+0x108>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 730:	06c00793          	li	a5,108
 734:	04f68263          	beq	a3,a5,778 <vprintf+0x122>
      } else if(c0 == 'l' && c1 == 'u'){
 738:	07500793          	li	a5,117
 73c:	0af68063          	beq	a3,a5,7dc <vprintf+0x186>
      } else if(c0 == 'l' && c1 == 'x'){
 740:	07800793          	li	a5,120
 744:	0ef68263          	beq	a3,a5,828 <vprintf+0x1d2>
        putc(fd, '%');
 748:	02500593          	li	a1,37
 74c:	855a                	mv	a0,s6
 74e:	e43ff0ef          	jal	590 <putc>
        putc(fd, c0);
 752:	85ca                	mv	a1,s2
 754:	855a                	mv	a0,s6
 756:	e3bff0ef          	jal	590 <putc>
      state = 0;
 75a:	4981                	li	s3,0
 75c:	b791                	j	6a0 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 75e:	008b8913          	addi	s2,s7,8
 762:	4685                	li	a3,1
 764:	4629                	li	a2,10
 766:	000ba583          	lw	a1,0(s7)
 76a:	855a                	mv	a0,s6
 76c:	e43ff0ef          	jal	5ae <printint>
        i += 1;
 770:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 772:	8bca                	mv	s7,s2
      state = 0;
 774:	4981                	li	s3,0
        i += 1;
 776:	b72d                	j	6a0 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 778:	06400793          	li	a5,100
 77c:	02f60763          	beq	a2,a5,7aa <vprintf+0x154>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 780:	07500793          	li	a5,117
 784:	06f60963          	beq	a2,a5,7f6 <vprintf+0x1a0>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 788:	07800793          	li	a5,120
 78c:	faf61ee3          	bne	a2,a5,748 <vprintf+0xf2>
        printint(fd, va_arg(ap, uint64), 16, 0);
 790:	008b8913          	addi	s2,s7,8
 794:	4681                	li	a3,0
 796:	4641                	li	a2,16
 798:	000ba583          	lw	a1,0(s7)
 79c:	855a                	mv	a0,s6
 79e:	e11ff0ef          	jal	5ae <printint>
        i += 2;
 7a2:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 7a4:	8bca                	mv	s7,s2
      state = 0;
 7a6:	4981                	li	s3,0
        i += 2;
 7a8:	bde5                	j	6a0 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 7aa:	008b8913          	addi	s2,s7,8
 7ae:	4685                	li	a3,1
 7b0:	4629                	li	a2,10
 7b2:	000ba583          	lw	a1,0(s7)
 7b6:	855a                	mv	a0,s6
 7b8:	df7ff0ef          	jal	5ae <printint>
        i += 2;
 7bc:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 7be:	8bca                	mv	s7,s2
      state = 0;
 7c0:	4981                	li	s3,0
        i += 2;
 7c2:	bdf9                	j	6a0 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 0);
 7c4:	008b8913          	addi	s2,s7,8
 7c8:	4681                	li	a3,0
 7ca:	4629                	li	a2,10
 7cc:	000ba583          	lw	a1,0(s7)
 7d0:	855a                	mv	a0,s6
 7d2:	dddff0ef          	jal	5ae <printint>
 7d6:	8bca                	mv	s7,s2
      state = 0;
 7d8:	4981                	li	s3,0
 7da:	b5d9                	j	6a0 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 7dc:	008b8913          	addi	s2,s7,8
 7e0:	4681                	li	a3,0
 7e2:	4629                	li	a2,10
 7e4:	000ba583          	lw	a1,0(s7)
 7e8:	855a                	mv	a0,s6
 7ea:	dc5ff0ef          	jal	5ae <printint>
        i += 1;
 7ee:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 7f0:	8bca                	mv	s7,s2
      state = 0;
 7f2:	4981                	li	s3,0
        i += 1;
 7f4:	b575                	j	6a0 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 7f6:	008b8913          	addi	s2,s7,8
 7fa:	4681                	li	a3,0
 7fc:	4629                	li	a2,10
 7fe:	000ba583          	lw	a1,0(s7)
 802:	855a                	mv	a0,s6
 804:	dabff0ef          	jal	5ae <printint>
        i += 2;
 808:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 80a:	8bca                	mv	s7,s2
      state = 0;
 80c:	4981                	li	s3,0
        i += 2;
 80e:	bd49                	j	6a0 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 16, 0);
 810:	008b8913          	addi	s2,s7,8
 814:	4681                	li	a3,0
 816:	4641                	li	a2,16
 818:	000ba583          	lw	a1,0(s7)
 81c:	855a                	mv	a0,s6
 81e:	d91ff0ef          	jal	5ae <printint>
 822:	8bca                	mv	s7,s2
      state = 0;
 824:	4981                	li	s3,0
 826:	bdad                	j	6a0 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 16, 0);
 828:	008b8913          	addi	s2,s7,8
 82c:	4681                	li	a3,0
 82e:	4641                	li	a2,16
 830:	000ba583          	lw	a1,0(s7)
 834:	855a                	mv	a0,s6
 836:	d79ff0ef          	jal	5ae <printint>
        i += 1;
 83a:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 83c:	8bca                	mv	s7,s2
      state = 0;
 83e:	4981                	li	s3,0
        i += 1;
 840:	b585                	j	6a0 <vprintf+0x4a>
 842:	e06a                	sd	s10,0(sp)
        printptr(fd, va_arg(ap, uint64));
 844:	008b8d13          	addi	s10,s7,8
 848:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 84c:	03000593          	li	a1,48
 850:	855a                	mv	a0,s6
 852:	d3fff0ef          	jal	590 <putc>
  putc(fd, 'x');
 856:	07800593          	li	a1,120
 85a:	855a                	mv	a0,s6
 85c:	d35ff0ef          	jal	590 <putc>
 860:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 862:	00000b97          	auipc	s7,0x0
 866:	2feb8b93          	addi	s7,s7,766 # b60 <digits>
 86a:	03c9d793          	srli	a5,s3,0x3c
 86e:	97de                	add	a5,a5,s7
 870:	0007c583          	lbu	a1,0(a5)
 874:	855a                	mv	a0,s6
 876:	d1bff0ef          	jal	590 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 87a:	0992                	slli	s3,s3,0x4
 87c:	397d                	addiw	s2,s2,-1
 87e:	fe0916e3          	bnez	s2,86a <vprintf+0x214>
        printptr(fd, va_arg(ap, uint64));
 882:	8bea                	mv	s7,s10
      state = 0;
 884:	4981                	li	s3,0
 886:	6d02                	ld	s10,0(sp)
 888:	bd21                	j	6a0 <vprintf+0x4a>
        if((s = va_arg(ap, char*)) == 0)
 88a:	008b8993          	addi	s3,s7,8
 88e:	000bb903          	ld	s2,0(s7)
 892:	00090f63          	beqz	s2,8b0 <vprintf+0x25a>
        for(; *s; s++)
 896:	00094583          	lbu	a1,0(s2)
 89a:	c195                	beqz	a1,8be <vprintf+0x268>
          putc(fd, *s);
 89c:	855a                	mv	a0,s6
 89e:	cf3ff0ef          	jal	590 <putc>
        for(; *s; s++)
 8a2:	0905                	addi	s2,s2,1
 8a4:	00094583          	lbu	a1,0(s2)
 8a8:	f9f5                	bnez	a1,89c <vprintf+0x246>
        if((s = va_arg(ap, char*)) == 0)
 8aa:	8bce                	mv	s7,s3
      state = 0;
 8ac:	4981                	li	s3,0
 8ae:	bbcd                	j	6a0 <vprintf+0x4a>
          s = "(null)";
 8b0:	00000917          	auipc	s2,0x0
 8b4:	2a890913          	addi	s2,s2,680 # b58 <malloc+0x19c>
        for(; *s; s++)
 8b8:	02800593          	li	a1,40
 8bc:	b7c5                	j	89c <vprintf+0x246>
        if((s = va_arg(ap, char*)) == 0)
 8be:	8bce                	mv	s7,s3
      state = 0;
 8c0:	4981                	li	s3,0
 8c2:	bbf9                	j	6a0 <vprintf+0x4a>
 8c4:	64a6                	ld	s1,72(sp)
 8c6:	79e2                	ld	s3,56(sp)
 8c8:	7a42                	ld	s4,48(sp)
 8ca:	7aa2                	ld	s5,40(sp)
 8cc:	7b02                	ld	s6,32(sp)
 8ce:	6be2                	ld	s7,24(sp)
 8d0:	6c42                	ld	s8,16(sp)
 8d2:	6ca2                	ld	s9,8(sp)
    }
  }
}
 8d4:	60e6                	ld	ra,88(sp)
 8d6:	6446                	ld	s0,80(sp)
 8d8:	6906                	ld	s2,64(sp)
 8da:	6125                	addi	sp,sp,96
 8dc:	8082                	ret

00000000000008de <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 8de:	715d                	addi	sp,sp,-80
 8e0:	ec06                	sd	ra,24(sp)
 8e2:	e822                	sd	s0,16(sp)
 8e4:	1000                	addi	s0,sp,32
 8e6:	e010                	sd	a2,0(s0)
 8e8:	e414                	sd	a3,8(s0)
 8ea:	e818                	sd	a4,16(s0)
 8ec:	ec1c                	sd	a5,24(s0)
 8ee:	03043023          	sd	a6,32(s0)
 8f2:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 8f6:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 8fa:	8622                	mv	a2,s0
 8fc:	d5bff0ef          	jal	656 <vprintf>
}
 900:	60e2                	ld	ra,24(sp)
 902:	6442                	ld	s0,16(sp)
 904:	6161                	addi	sp,sp,80
 906:	8082                	ret

0000000000000908 <printf>:

void
printf(const char *fmt, ...)
{
 908:	711d                	addi	sp,sp,-96
 90a:	ec06                	sd	ra,24(sp)
 90c:	e822                	sd	s0,16(sp)
 90e:	1000                	addi	s0,sp,32
 910:	e40c                	sd	a1,8(s0)
 912:	e810                	sd	a2,16(s0)
 914:	ec14                	sd	a3,24(s0)
 916:	f018                	sd	a4,32(s0)
 918:	f41c                	sd	a5,40(s0)
 91a:	03043823          	sd	a6,48(s0)
 91e:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 922:	00840613          	addi	a2,s0,8
 926:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 92a:	85aa                	mv	a1,a0
 92c:	4505                	li	a0,1
 92e:	d29ff0ef          	jal	656 <vprintf>
}
 932:	60e2                	ld	ra,24(sp)
 934:	6442                	ld	s0,16(sp)
 936:	6125                	addi	sp,sp,96
 938:	8082                	ret

000000000000093a <free>:
 93a:	1141                	addi	sp,sp,-16
 93c:	e422                	sd	s0,8(sp)
 93e:	0800                	addi	s0,sp,16
 940:	ff050693          	addi	a3,a0,-16
 944:	00001797          	auipc	a5,0x1
 948:	6bc7b783          	ld	a5,1724(a5) # 2000 <freep>
 94c:	a02d                	j	976 <free+0x3c>
 94e:	4618                	lw	a4,8(a2)
 950:	9f2d                	addw	a4,a4,a1
 952:	fee52c23          	sw	a4,-8(a0)
 956:	6398                	ld	a4,0(a5)
 958:	6310                	ld	a2,0(a4)
 95a:	a83d                	j	998 <free+0x5e>
 95c:	ff852703          	lw	a4,-8(a0)
 960:	9f31                	addw	a4,a4,a2
 962:	c798                	sw	a4,8(a5)
 964:	ff053683          	ld	a3,-16(a0)
 968:	a091                	j	9ac <free+0x72>
 96a:	6398                	ld	a4,0(a5)
 96c:	00e7e463          	bltu	a5,a4,974 <free+0x3a>
 970:	00e6ea63          	bltu	a3,a4,984 <free+0x4a>
 974:	87ba                	mv	a5,a4
 976:	fed7fae3          	bgeu	a5,a3,96a <free+0x30>
 97a:	6398                	ld	a4,0(a5)
 97c:	00e6e463          	bltu	a3,a4,984 <free+0x4a>
 980:	fee7eae3          	bltu	a5,a4,974 <free+0x3a>
 984:	ff852583          	lw	a1,-8(a0)
 988:	6390                	ld	a2,0(a5)
 98a:	02059813          	slli	a6,a1,0x20
 98e:	01c85713          	srli	a4,a6,0x1c
 992:	9736                	add	a4,a4,a3
 994:	fae60de3          	beq	a2,a4,94e <free+0x14>
 998:	fec53823          	sd	a2,-16(a0)
 99c:	4790                	lw	a2,8(a5)
 99e:	02061593          	slli	a1,a2,0x20
 9a2:	01c5d713          	srli	a4,a1,0x1c
 9a6:	973e                	add	a4,a4,a5
 9a8:	fae68ae3          	beq	a3,a4,95c <free+0x22>
 9ac:	e394                	sd	a3,0(a5)
 9ae:	00001717          	auipc	a4,0x1
 9b2:	64f73923          	sd	a5,1618(a4) # 2000 <freep>
 9b6:	6422                	ld	s0,8(sp)
 9b8:	0141                	addi	sp,sp,16
 9ba:	8082                	ret

00000000000009bc <malloc>:
 9bc:	7139                	addi	sp,sp,-64
 9be:	fc06                	sd	ra,56(sp)
 9c0:	f822                	sd	s0,48(sp)
 9c2:	f426                	sd	s1,40(sp)
 9c4:	ec4e                	sd	s3,24(sp)
 9c6:	0080                	addi	s0,sp,64
 9c8:	02051493          	slli	s1,a0,0x20
 9cc:	9081                	srli	s1,s1,0x20
 9ce:	04bd                	addi	s1,s1,15
 9d0:	8091                	srli	s1,s1,0x4
 9d2:	0014899b          	addiw	s3,s1,1
 9d6:	0485                	addi	s1,s1,1
 9d8:	00001517          	auipc	a0,0x1
 9dc:	62853503          	ld	a0,1576(a0) # 2000 <freep>
 9e0:	c915                	beqz	a0,a14 <malloc+0x58>
 9e2:	611c                	ld	a5,0(a0)
 9e4:	4798                	lw	a4,8(a5)
 9e6:	08977a63          	bgeu	a4,s1,a7a <malloc+0xbe>
 9ea:	f04a                	sd	s2,32(sp)
 9ec:	e852                	sd	s4,16(sp)
 9ee:	e456                	sd	s5,8(sp)
 9f0:	e05a                	sd	s6,0(sp)
 9f2:	8a4e                	mv	s4,s3
 9f4:	0009871b          	sext.w	a4,s3
 9f8:	6685                	lui	a3,0x1
 9fa:	00d77363          	bgeu	a4,a3,a00 <malloc+0x44>
 9fe:	6a05                	lui	s4,0x1
 a00:	000a0b1b          	sext.w	s6,s4
 a04:	004a1a1b          	slliw	s4,s4,0x4
 a08:	00001917          	auipc	s2,0x1
 a0c:	5f890913          	addi	s2,s2,1528 # 2000 <freep>
 a10:	5afd                	li	s5,-1
 a12:	a081                	j	a52 <malloc+0x96>
 a14:	f04a                	sd	s2,32(sp)
 a16:	e852                	sd	s4,16(sp)
 a18:	e456                	sd	s5,8(sp)
 a1a:	e05a                	sd	s6,0(sp)
 a1c:	00001797          	auipc	a5,0x1
 a20:	5f478793          	addi	a5,a5,1524 # 2010 <base>
 a24:	00001717          	auipc	a4,0x1
 a28:	5cf73e23          	sd	a5,1500(a4) # 2000 <freep>
 a2c:	e39c                	sd	a5,0(a5)
 a2e:	0007a423          	sw	zero,8(a5)
 a32:	b7c1                	j	9f2 <malloc+0x36>
 a34:	6398                	ld	a4,0(a5)
 a36:	e118                	sd	a4,0(a0)
 a38:	a8a9                	j	a92 <malloc+0xd6>
 a3a:	01652423          	sw	s6,8(a0)
 a3e:	0541                	addi	a0,a0,16
 a40:	efbff0ef          	jal	93a <free>
 a44:	00093503          	ld	a0,0(s2)
 a48:	c12d                	beqz	a0,aaa <malloc+0xee>
 a4a:	611c                	ld	a5,0(a0)
 a4c:	4798                	lw	a4,8(a5)
 a4e:	02977263          	bgeu	a4,s1,a72 <malloc+0xb6>
 a52:	00093703          	ld	a4,0(s2)
 a56:	853e                	mv	a0,a5
 a58:	fef719e3          	bne	a4,a5,a4a <malloc+0x8e>
 a5c:	8552                	mv	a0,s4
 a5e:	b13ff0ef          	jal	570 <sbrk>
 a62:	fd551ce3          	bne	a0,s5,a3a <malloc+0x7e>
 a66:	4501                	li	a0,0
 a68:	7902                	ld	s2,32(sp)
 a6a:	6a42                	ld	s4,16(sp)
 a6c:	6aa2                	ld	s5,8(sp)
 a6e:	6b02                	ld	s6,0(sp)
 a70:	a03d                	j	a9e <malloc+0xe2>
 a72:	7902                	ld	s2,32(sp)
 a74:	6a42                	ld	s4,16(sp)
 a76:	6aa2                	ld	s5,8(sp)
 a78:	6b02                	ld	s6,0(sp)
 a7a:	fae48de3          	beq	s1,a4,a34 <malloc+0x78>
 a7e:	4137073b          	subw	a4,a4,s3
 a82:	c798                	sw	a4,8(a5)
 a84:	02071693          	slli	a3,a4,0x20
 a88:	01c6d713          	srli	a4,a3,0x1c
 a8c:	97ba                	add	a5,a5,a4
 a8e:	0137a423          	sw	s3,8(a5)
 a92:	00001717          	auipc	a4,0x1
 a96:	56a73723          	sd	a0,1390(a4) # 2000 <freep>
 a9a:	01078513          	addi	a0,a5,16
 a9e:	70e2                	ld	ra,56(sp)
 aa0:	7442                	ld	s0,48(sp)
 aa2:	74a2                	ld	s1,40(sp)
 aa4:	69e2                	ld	s3,24(sp)
 aa6:	6121                	addi	sp,sp,64
 aa8:	8082                	ret
 aaa:	7902                	ld	s2,32(sp)
 aac:	6a42                	ld	s4,16(sp)
 aae:	6aa2                	ld	s5,8(sp)
 ab0:	6b02                	ld	s6,0(sp)
 ab2:	b7f5                	j	a9e <malloc+0xe2>
