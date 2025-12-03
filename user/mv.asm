
user/_mv:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <strcat>:
#include "kernel/stat.h"
#include "kernel/fs.h"
#include "user/user.h"

// Manual strcat implementation for xv6
char* strcat(char *dest, const char *src) {
   0:	1141                	addi	sp,sp,-16
   2:	e422                	sd	s0,8(sp)
   4:	0800                	addi	s0,sp,16
    char *ptr = dest;
    while (*ptr != '\0') {
   6:	00054783          	lbu	a5,0(a0)
   a:	c78d                	beqz	a5,34 <strcat+0x34>
    char *ptr = dest;
   c:	87aa                	mv	a5,a0
        ptr++;
   e:	0785                	addi	a5,a5,1
    while (*ptr != '\0') {
  10:	0007c703          	lbu	a4,0(a5)
  14:	ff6d                	bnez	a4,e <strcat+0xe>
    }
    while (*src != '\0') {
  16:	0005c703          	lbu	a4,0(a1)
  1a:	cb01                	beqz	a4,2a <strcat+0x2a>
        *ptr++ = *src++;
  1c:	0585                	addi	a1,a1,1
  1e:	0785                	addi	a5,a5,1
  20:	fee78fa3          	sb	a4,-1(a5)
    while (*src != '\0') {
  24:	0005c703          	lbu	a4,0(a1)
  28:	fb75                	bnez	a4,1c <strcat+0x1c>
    }
    *ptr = '\0';
  2a:	00078023          	sb	zero,0(a5)
    return dest;
}
  2e:	6422                	ld	s0,8(sp)
  30:	0141                	addi	sp,sp,16
  32:	8082                	ret
    char *ptr = dest;
  34:	87aa                	mv	a5,a0
  36:	b7c5                	j	16 <strcat+0x16>

0000000000000038 <get_filename>:

// Extract filename from path
char* get_filename(char *path) {
  38:	1101                	addi	sp,sp,-32
  3a:	ec06                	sd	ra,24(sp)
  3c:	e822                	sd	s0,16(sp)
  3e:	e426                	sd	s1,8(sp)
  40:	1000                	addi	s0,sp,32
  42:	84aa                	mv	s1,a0
    char *p = path + strlen(path);
  44:	1ce000ef          	jal	212 <strlen>
  48:	02051793          	slli	a5,a0,0x20
  4c:	9381                	srli	a5,a5,0x20
  4e:	97a6                	add	a5,a5,s1
    while (p > path && *p != '/') {
  50:	02f00693          	li	a3,47
  54:	00f4fa63          	bgeu	s1,a5,68 <get_filename+0x30>
  58:	0007c703          	lbu	a4,0(a5)
  5c:	00d70663          	beq	a4,a3,68 <get_filename+0x30>
        p--;
  60:	17fd                	addi	a5,a5,-1
    while (p > path && *p != '/') {
  62:	fef49be3          	bne	s1,a5,58 <get_filename+0x20>
  66:	87a6                	mv	a5,s1
    }
    if (*p == '/') p++;
  68:	0007c503          	lbu	a0,0(a5)
  6c:	fd150513          	addi	a0,a0,-47
  70:	00153513          	seqz	a0,a0
    return p;
}
  74:	953e                	add	a0,a0,a5
  76:	60e2                	ld	ra,24(sp)
  78:	6442                	ld	s0,16(sp)
  7a:	64a2                	ld	s1,8(sp)
  7c:	6105                	addi	sp,sp,32
  7e:	8082                	ret

0000000000000080 <main>:

int main(int argc, char *argv[]) {
  80:	db010113          	addi	sp,sp,-592
  84:	24113423          	sd	ra,584(sp)
  88:	24813023          	sd	s0,576(sp)
  8c:	0c80                	addi	s0,sp,592
    struct stat st;
    char newpath[512];

    if (argc != 3) {
  8e:	478d                	li	a5,3
  90:	02f50263          	beq	a0,a5,b4 <main+0x34>
  94:	22913c23          	sd	s1,568(sp)
  98:	23213823          	sd	s2,560(sp)
  9c:	23313423          	sd	s3,552(sp)
        fprintf(2, "Usage: mv source destination\n");
  a0:	00001597          	auipc	a1,0x1
  a4:	97058593          	addi	a1,a1,-1680 # a10 <malloc+0xfa>
  a8:	4509                	li	a0,2
  aa:	78e000ef          	jal	838 <fprintf>
        exit(1);
  ae:	4505                	li	a0,1
  b0:	372000ef          	jal	422 <exit>
  b4:	22913c23          	sd	s1,568(sp)
  b8:	23213823          	sd	s2,560(sp)
    }

    char *source = argv[1];
  bc:	6584                	ld	s1,8(a1)
    char *dest = argv[2];
  be:	0105b903          	ld	s2,16(a1)

    // Check if source exists
    if (stat(source, &st) < 0) {
  c2:	fb840593          	addi	a1,s0,-72
  c6:	8526                	mv	a0,s1
  c8:	22a000ef          	jal	2f2 <stat>
  cc:	04054363          	bltz	a0,112 <main+0x92>
  d0:	23313423          	sd	s3,552(sp)
        fprintf(2, "mv: cannot stat %s\n", source);
        exit(1);
    }

    // Check if destination is a directory
    if (stat(dest, &st) == 0 && st.type == T_DIR) {
  d4:	fb840593          	addi	a1,s0,-72
  d8:	854a                	mv	a0,s2
  da:	218000ef          	jal	2f2 <stat>
  de:	e511                	bnez	a0,ea <main+0x6a>
  e0:	fc041703          	lh	a4,-64(s0)
  e4:	4785                	li	a5,1
  e6:	04f70363          	beq	a4,a5,12c <main+0xac>
            strcat(newpath, "/");
        }
        strcat(newpath, filename);
    } else {
        // Destination is a file or doesn't exist
        strcpy(newpath, dest);
  ea:	85ca                	mv	a1,s2
  ec:	db840513          	addi	a0,s0,-584
  f0:	0da000ef          	jal	1ca <strcpy>
    }

    // Perform the move using link and unlink
    if (link(source, newpath) < 0) {
  f4:	db840593          	addi	a1,s0,-584
  f8:	8526                	mv	a0,s1
  fa:	388000ef          	jal	482 <link>
  fe:	08054563          	bltz	a0,188 <main+0x108>
        fprintf(2, "mv: link failed\n");
        exit(1);
    }

    if (unlink(source) < 0) {
 102:	8526                	mv	a0,s1
 104:	36e000ef          	jal	472 <unlink>
 108:	08054a63          	bltz	a0,19c <main+0x11c>
        fprintf(2, "mv: unlink failed\n");
        unlink(newpath); // Cleanup
        exit(1);
    }

    exit(0);
 10c:	4501                	li	a0,0
 10e:	314000ef          	jal	422 <exit>
 112:	23313423          	sd	s3,552(sp)
        fprintf(2, "mv: cannot stat %s\n", source);
 116:	8626                	mv	a2,s1
 118:	00001597          	auipc	a1,0x1
 11c:	91858593          	addi	a1,a1,-1768 # a30 <malloc+0x11a>
 120:	4509                	li	a0,2
 122:	716000ef          	jal	838 <fprintf>
        exit(1);
 126:	4505                	li	a0,1
 128:	2fa000ef          	jal	422 <exit>
        char *filename = get_filename(source);
 12c:	8526                	mv	a0,s1
 12e:	f0bff0ef          	jal	38 <get_filename>
 132:	89aa                	mv	s3,a0
        strcpy(newpath, dest);
 134:	85ca                	mv	a1,s2
 136:	db840513          	addi	a0,s0,-584
 13a:	090000ef          	jal	1ca <strcpy>
        if (newpath[strlen(newpath) - 1] != '/') {
 13e:	db840513          	addi	a0,s0,-584
 142:	0d0000ef          	jal	212 <strlen>
 146:	fff5079b          	addiw	a5,a0,-1
 14a:	1782                	slli	a5,a5,0x20
 14c:	9381                	srli	a5,a5,0x20
 14e:	fd078793          	addi	a5,a5,-48
 152:	97a2                	add	a5,a5,s0
 154:	de87c703          	lbu	a4,-536(a5)
 158:	02f00793          	li	a5,47
 15c:	00f71863          	bne	a4,a5,16c <main+0xec>
        strcat(newpath, filename);
 160:	85ce                	mv	a1,s3
 162:	db840513          	addi	a0,s0,-584
 166:	e9bff0ef          	jal	0 <strcat>
    if (stat(dest, &st) == 0 && st.type == T_DIR) {
 16a:	b769                	j	f4 <main+0x74>
            strcat(newpath, "/");
 16c:	db840513          	addi	a0,s0,-584
 170:	0a2000ef          	jal	212 <strlen>
 174:	db840793          	addi	a5,s0,-584
 178:	97aa                	add	a5,a5,a0
 17a:	02f00713          	li	a4,47
 17e:	00e78023          	sb	a4,0(a5)
 182:	000780a3          	sb	zero,1(a5)
 186:	bfe9                	j	160 <main+0xe0>
        fprintf(2, "mv: link failed\n");
 188:	00001597          	auipc	a1,0x1
 18c:	8c058593          	addi	a1,a1,-1856 # a48 <malloc+0x132>
 190:	4509                	li	a0,2
 192:	6a6000ef          	jal	838 <fprintf>
        exit(1);
 196:	4505                	li	a0,1
 198:	28a000ef          	jal	422 <exit>
        fprintf(2, "mv: unlink failed\n");
 19c:	00001597          	auipc	a1,0x1
 1a0:	8c458593          	addi	a1,a1,-1852 # a60 <malloc+0x14a>
 1a4:	4509                	li	a0,2
 1a6:	692000ef          	jal	838 <fprintf>
        unlink(newpath); // Cleanup
 1aa:	db840513          	addi	a0,s0,-584
 1ae:	2c4000ef          	jal	472 <unlink>
        exit(1);
 1b2:	4505                	li	a0,1
 1b4:	26e000ef          	jal	422 <exit>

00000000000001b8 <start>:
 1b8:	1141                	addi	sp,sp,-16
 1ba:	e406                	sd	ra,8(sp)
 1bc:	e022                	sd	s0,0(sp)
 1be:	0800                	addi	s0,sp,16
 1c0:	ec1ff0ef          	jal	80 <main>
 1c4:	4501                	li	a0,0
 1c6:	25c000ef          	jal	422 <exit>

00000000000001ca <strcpy>:
 1ca:	1141                	addi	sp,sp,-16
 1cc:	e422                	sd	s0,8(sp)
 1ce:	0800                	addi	s0,sp,16
 1d0:	87aa                	mv	a5,a0
 1d2:	0585                	addi	a1,a1,1
 1d4:	0785                	addi	a5,a5,1
 1d6:	fff5c703          	lbu	a4,-1(a1)
 1da:	fee78fa3          	sb	a4,-1(a5)
 1de:	fb75                	bnez	a4,1d2 <strcpy+0x8>
 1e0:	6422                	ld	s0,8(sp)
 1e2:	0141                	addi	sp,sp,16
 1e4:	8082                	ret

00000000000001e6 <strcmp>:
 1e6:	1141                	addi	sp,sp,-16
 1e8:	e422                	sd	s0,8(sp)
 1ea:	0800                	addi	s0,sp,16
 1ec:	00054783          	lbu	a5,0(a0)
 1f0:	cb91                	beqz	a5,204 <strcmp+0x1e>
 1f2:	0005c703          	lbu	a4,0(a1)
 1f6:	00f71763          	bne	a4,a5,204 <strcmp+0x1e>
 1fa:	0505                	addi	a0,a0,1
 1fc:	0585                	addi	a1,a1,1
 1fe:	00054783          	lbu	a5,0(a0)
 202:	fbe5                	bnez	a5,1f2 <strcmp+0xc>
 204:	0005c503          	lbu	a0,0(a1)
 208:	40a7853b          	subw	a0,a5,a0
 20c:	6422                	ld	s0,8(sp)
 20e:	0141                	addi	sp,sp,16
 210:	8082                	ret

0000000000000212 <strlen>:
 212:	1141                	addi	sp,sp,-16
 214:	e422                	sd	s0,8(sp)
 216:	0800                	addi	s0,sp,16
 218:	00054783          	lbu	a5,0(a0)
 21c:	cf91                	beqz	a5,238 <strlen+0x26>
 21e:	0505                	addi	a0,a0,1
 220:	87aa                	mv	a5,a0
 222:	86be                	mv	a3,a5
 224:	0785                	addi	a5,a5,1
 226:	fff7c703          	lbu	a4,-1(a5)
 22a:	ff65                	bnez	a4,222 <strlen+0x10>
 22c:	40a6853b          	subw	a0,a3,a0
 230:	2505                	addiw	a0,a0,1
 232:	6422                	ld	s0,8(sp)
 234:	0141                	addi	sp,sp,16
 236:	8082                	ret
 238:	4501                	li	a0,0
 23a:	bfe5                	j	232 <strlen+0x20>

000000000000023c <memset>:
 23c:	1141                	addi	sp,sp,-16
 23e:	e422                	sd	s0,8(sp)
 240:	0800                	addi	s0,sp,16
 242:	ca19                	beqz	a2,258 <memset+0x1c>
 244:	87aa                	mv	a5,a0
 246:	1602                	slli	a2,a2,0x20
 248:	9201                	srli	a2,a2,0x20
 24a:	00a60733          	add	a4,a2,a0
 24e:	00b78023          	sb	a1,0(a5)
 252:	0785                	addi	a5,a5,1
 254:	fee79de3          	bne	a5,a4,24e <memset+0x12>
 258:	6422                	ld	s0,8(sp)
 25a:	0141                	addi	sp,sp,16
 25c:	8082                	ret

000000000000025e <strchr>:
 25e:	1141                	addi	sp,sp,-16
 260:	e422                	sd	s0,8(sp)
 262:	0800                	addi	s0,sp,16
 264:	00054783          	lbu	a5,0(a0)
 268:	cb99                	beqz	a5,27e <strchr+0x20>
 26a:	00f58763          	beq	a1,a5,278 <strchr+0x1a>
 26e:	0505                	addi	a0,a0,1
 270:	00054783          	lbu	a5,0(a0)
 274:	fbfd                	bnez	a5,26a <strchr+0xc>
 276:	4501                	li	a0,0
 278:	6422                	ld	s0,8(sp)
 27a:	0141                	addi	sp,sp,16
 27c:	8082                	ret
 27e:	4501                	li	a0,0
 280:	bfe5                	j	278 <strchr+0x1a>

0000000000000282 <gets>:
 282:	711d                	addi	sp,sp,-96
 284:	ec86                	sd	ra,88(sp)
 286:	e8a2                	sd	s0,80(sp)
 288:	e4a6                	sd	s1,72(sp)
 28a:	e0ca                	sd	s2,64(sp)
 28c:	fc4e                	sd	s3,56(sp)
 28e:	f852                	sd	s4,48(sp)
 290:	f456                	sd	s5,40(sp)
 292:	f05a                	sd	s6,32(sp)
 294:	ec5e                	sd	s7,24(sp)
 296:	1080                	addi	s0,sp,96
 298:	8baa                	mv	s7,a0
 29a:	8a2e                	mv	s4,a1
 29c:	892a                	mv	s2,a0
 29e:	4481                	li	s1,0
 2a0:	4aa9                	li	s5,10
 2a2:	4b35                	li	s6,13
 2a4:	89a6                	mv	s3,s1
 2a6:	2485                	addiw	s1,s1,1
 2a8:	0344d663          	bge	s1,s4,2d4 <gets+0x52>
 2ac:	4605                	li	a2,1
 2ae:	faf40593          	addi	a1,s0,-81
 2b2:	4501                	li	a0,0
 2b4:	186000ef          	jal	43a <read>
 2b8:	00a05e63          	blez	a0,2d4 <gets+0x52>
 2bc:	faf44783          	lbu	a5,-81(s0)
 2c0:	00f90023          	sb	a5,0(s2)
 2c4:	01578763          	beq	a5,s5,2d2 <gets+0x50>
 2c8:	0905                	addi	s2,s2,1
 2ca:	fd679de3          	bne	a5,s6,2a4 <gets+0x22>
 2ce:	89a6                	mv	s3,s1
 2d0:	a011                	j	2d4 <gets+0x52>
 2d2:	89a6                	mv	s3,s1
 2d4:	99de                	add	s3,s3,s7
 2d6:	00098023          	sb	zero,0(s3)
 2da:	855e                	mv	a0,s7
 2dc:	60e6                	ld	ra,88(sp)
 2de:	6446                	ld	s0,80(sp)
 2e0:	64a6                	ld	s1,72(sp)
 2e2:	6906                	ld	s2,64(sp)
 2e4:	79e2                	ld	s3,56(sp)
 2e6:	7a42                	ld	s4,48(sp)
 2e8:	7aa2                	ld	s5,40(sp)
 2ea:	7b02                	ld	s6,32(sp)
 2ec:	6be2                	ld	s7,24(sp)
 2ee:	6125                	addi	sp,sp,96
 2f0:	8082                	ret

00000000000002f2 <stat>:
 2f2:	1101                	addi	sp,sp,-32
 2f4:	ec06                	sd	ra,24(sp)
 2f6:	e822                	sd	s0,16(sp)
 2f8:	e04a                	sd	s2,0(sp)
 2fa:	1000                	addi	s0,sp,32
 2fc:	892e                	mv	s2,a1
 2fe:	4581                	li	a1,0
 300:	162000ef          	jal	462 <open>
 304:	02054263          	bltz	a0,328 <stat+0x36>
 308:	e426                	sd	s1,8(sp)
 30a:	84aa                	mv	s1,a0
 30c:	85ca                	mv	a1,s2
 30e:	16c000ef          	jal	47a <fstat>
 312:	892a                	mv	s2,a0
 314:	8526                	mv	a0,s1
 316:	134000ef          	jal	44a <close>
 31a:	64a2                	ld	s1,8(sp)
 31c:	854a                	mv	a0,s2
 31e:	60e2                	ld	ra,24(sp)
 320:	6442                	ld	s0,16(sp)
 322:	6902                	ld	s2,0(sp)
 324:	6105                	addi	sp,sp,32
 326:	8082                	ret
 328:	597d                	li	s2,-1
 32a:	bfcd                	j	31c <stat+0x2a>

000000000000032c <atoi>:
 32c:	1141                	addi	sp,sp,-16
 32e:	e422                	sd	s0,8(sp)
 330:	0800                	addi	s0,sp,16
 332:	00054683          	lbu	a3,0(a0)
 336:	fd06879b          	addiw	a5,a3,-48
 33a:	0ff7f793          	zext.b	a5,a5
 33e:	4625                	li	a2,9
 340:	02f66863          	bltu	a2,a5,370 <atoi+0x44>
 344:	872a                	mv	a4,a0
 346:	4501                	li	a0,0
 348:	0705                	addi	a4,a4,1
 34a:	0025179b          	slliw	a5,a0,0x2
 34e:	9fa9                	addw	a5,a5,a0
 350:	0017979b          	slliw	a5,a5,0x1
 354:	9fb5                	addw	a5,a5,a3
 356:	fd07851b          	addiw	a0,a5,-48
 35a:	00074683          	lbu	a3,0(a4)
 35e:	fd06879b          	addiw	a5,a3,-48
 362:	0ff7f793          	zext.b	a5,a5
 366:	fef671e3          	bgeu	a2,a5,348 <atoi+0x1c>
 36a:	6422                	ld	s0,8(sp)
 36c:	0141                	addi	sp,sp,16
 36e:	8082                	ret
 370:	4501                	li	a0,0
 372:	bfe5                	j	36a <atoi+0x3e>

0000000000000374 <memmove>:
 374:	1141                	addi	sp,sp,-16
 376:	e422                	sd	s0,8(sp)
 378:	0800                	addi	s0,sp,16
 37a:	02b57463          	bgeu	a0,a1,3a2 <memmove+0x2e>
 37e:	00c05f63          	blez	a2,39c <memmove+0x28>
 382:	1602                	slli	a2,a2,0x20
 384:	9201                	srli	a2,a2,0x20
 386:	00c507b3          	add	a5,a0,a2
 38a:	872a                	mv	a4,a0
 38c:	0585                	addi	a1,a1,1
 38e:	0705                	addi	a4,a4,1
 390:	fff5c683          	lbu	a3,-1(a1)
 394:	fed70fa3          	sb	a3,-1(a4)
 398:	fef71ae3          	bne	a4,a5,38c <memmove+0x18>
 39c:	6422                	ld	s0,8(sp)
 39e:	0141                	addi	sp,sp,16
 3a0:	8082                	ret
 3a2:	00c50733          	add	a4,a0,a2
 3a6:	95b2                	add	a1,a1,a2
 3a8:	fec05ae3          	blez	a2,39c <memmove+0x28>
 3ac:	fff6079b          	addiw	a5,a2,-1
 3b0:	1782                	slli	a5,a5,0x20
 3b2:	9381                	srli	a5,a5,0x20
 3b4:	fff7c793          	not	a5,a5
 3b8:	97ba                	add	a5,a5,a4
 3ba:	15fd                	addi	a1,a1,-1
 3bc:	177d                	addi	a4,a4,-1
 3be:	0005c683          	lbu	a3,0(a1)
 3c2:	00d70023          	sb	a3,0(a4)
 3c6:	fee79ae3          	bne	a5,a4,3ba <memmove+0x46>
 3ca:	bfc9                	j	39c <memmove+0x28>

00000000000003cc <memcmp>:
 3cc:	1141                	addi	sp,sp,-16
 3ce:	e422                	sd	s0,8(sp)
 3d0:	0800                	addi	s0,sp,16
 3d2:	ca05                	beqz	a2,402 <memcmp+0x36>
 3d4:	fff6069b          	addiw	a3,a2,-1
 3d8:	1682                	slli	a3,a3,0x20
 3da:	9281                	srli	a3,a3,0x20
 3dc:	0685                	addi	a3,a3,1
 3de:	96aa                	add	a3,a3,a0
 3e0:	00054783          	lbu	a5,0(a0)
 3e4:	0005c703          	lbu	a4,0(a1)
 3e8:	00e79863          	bne	a5,a4,3f8 <memcmp+0x2c>
 3ec:	0505                	addi	a0,a0,1
 3ee:	0585                	addi	a1,a1,1
 3f0:	fed518e3          	bne	a0,a3,3e0 <memcmp+0x14>
 3f4:	4501                	li	a0,0
 3f6:	a019                	j	3fc <memcmp+0x30>
 3f8:	40e7853b          	subw	a0,a5,a4
 3fc:	6422                	ld	s0,8(sp)
 3fe:	0141                	addi	sp,sp,16
 400:	8082                	ret
 402:	4501                	li	a0,0
 404:	bfe5                	j	3fc <memcmp+0x30>

0000000000000406 <memcpy>:
 406:	1141                	addi	sp,sp,-16
 408:	e406                	sd	ra,8(sp)
 40a:	e022                	sd	s0,0(sp)
 40c:	0800                	addi	s0,sp,16
 40e:	f67ff0ef          	jal	374 <memmove>
 412:	60a2                	ld	ra,8(sp)
 414:	6402                	ld	s0,0(sp)
 416:	0141                	addi	sp,sp,16
 418:	8082                	ret

000000000000041a <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 41a:	4885                	li	a7,1
 ecall
 41c:	00000073          	ecall
 ret
 420:	8082                	ret

0000000000000422 <exit>:
.global exit
exit:
 li a7, SYS_exit
 422:	4889                	li	a7,2
 ecall
 424:	00000073          	ecall
 ret
 428:	8082                	ret

000000000000042a <wait>:
.global wait
wait:
 li a7, SYS_wait
 42a:	488d                	li	a7,3
 ecall
 42c:	00000073          	ecall
 ret
 430:	8082                	ret

0000000000000432 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 432:	4891                	li	a7,4
 ecall
 434:	00000073          	ecall
 ret
 438:	8082                	ret

000000000000043a <read>:
.global read
read:
 li a7, SYS_read
 43a:	4895                	li	a7,5
 ecall
 43c:	00000073          	ecall
 ret
 440:	8082                	ret

0000000000000442 <write>:
.global write
write:
 li a7, SYS_write
 442:	48c1                	li	a7,16
 ecall
 444:	00000073          	ecall
 ret
 448:	8082                	ret

000000000000044a <close>:
.global close
close:
 li a7, SYS_close
 44a:	48d5                	li	a7,21
 ecall
 44c:	00000073          	ecall
 ret
 450:	8082                	ret

0000000000000452 <kill>:
.global kill
kill:
 li a7, SYS_kill
 452:	4899                	li	a7,6
 ecall
 454:	00000073          	ecall
 ret
 458:	8082                	ret

000000000000045a <exec>:
.global exec
exec:
 li a7, SYS_exec
 45a:	489d                	li	a7,7
 ecall
 45c:	00000073          	ecall
 ret
 460:	8082                	ret

0000000000000462 <open>:
.global open
open:
 li a7, SYS_open
 462:	48bd                	li	a7,15
 ecall
 464:	00000073          	ecall
 ret
 468:	8082                	ret

000000000000046a <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 46a:	48c5                	li	a7,17
 ecall
 46c:	00000073          	ecall
 ret
 470:	8082                	ret

0000000000000472 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 472:	48c9                	li	a7,18
 ecall
 474:	00000073          	ecall
 ret
 478:	8082                	ret

000000000000047a <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 47a:	48a1                	li	a7,8
 ecall
 47c:	00000073          	ecall
 ret
 480:	8082                	ret

0000000000000482 <link>:
.global link
link:
 li a7, SYS_link
 482:	48cd                	li	a7,19
 ecall
 484:	00000073          	ecall
 ret
 488:	8082                	ret

000000000000048a <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 48a:	48d1                	li	a7,20
 ecall
 48c:	00000073          	ecall
 ret
 490:	8082                	ret

0000000000000492 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 492:	48a5                	li	a7,9
 ecall
 494:	00000073          	ecall
 ret
 498:	8082                	ret

000000000000049a <dup>:
.global dup
dup:
 li a7, SYS_dup
 49a:	48a9                	li	a7,10
 ecall
 49c:	00000073          	ecall
 ret
 4a0:	8082                	ret

00000000000004a2 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 4a2:	48ad                	li	a7,11
 ecall
 4a4:	00000073          	ecall
 ret
 4a8:	8082                	ret

00000000000004aa <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 4aa:	48b1                	li	a7,12
 ecall
 4ac:	00000073          	ecall
 ret
 4b0:	8082                	ret

00000000000004b2 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 4b2:	48b5                	li	a7,13
 ecall
 4b4:	00000073          	ecall
 ret
 4b8:	8082                	ret

00000000000004ba <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 4ba:	48b9                	li	a7,14
 ecall
 4bc:	00000073          	ecall
 ret
 4c0:	8082                	ret

00000000000004c2 <kbdint>:
.global kbdint
kbdint:
 li a7, SYS_kbdint
 4c2:	48d9                	li	a7,22
 ecall
 4c4:	00000073          	ecall
 ret
 4c8:	8082                	ret

00000000000004ca <countsyscall>:
.global countsyscall
countsyscall:
 li a7, SYS_countsyscall
 4ca:	48dd                	li	a7,23
 ecall
 4cc:	00000073          	ecall
 ret
 4d0:	8082                	ret

00000000000004d2 <getppid>:
.global getppid
getppid:
 li a7, SYS_getppid
 4d2:	48e1                	li	a7,24
 ecall
 4d4:	00000073          	ecall
 ret
 4d8:	8082                	ret

00000000000004da <shutdown>:
.global shutdown
shutdown:
 li a7, SYS_shutdown
 4da:	48e5                	li	a7,25
 ecall
 4dc:	00000073          	ecall
 ret
 4e0:	8082                	ret

00000000000004e2 <rand>:
.global rand
rand:
 li a7, SYS_rand
 4e2:	48ed                	li	a7,27
 ecall
 4e4:	00000073          	ecall
 ret
 4e8:	8082                	ret

00000000000004ea <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 4ea:	1101                	addi	sp,sp,-32
 4ec:	ec06                	sd	ra,24(sp)
 4ee:	e822                	sd	s0,16(sp)
 4f0:	1000                	addi	s0,sp,32
 4f2:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 4f6:	4605                	li	a2,1
 4f8:	fef40593          	addi	a1,s0,-17
 4fc:	f47ff0ef          	jal	442 <write>
}
 500:	60e2                	ld	ra,24(sp)
 502:	6442                	ld	s0,16(sp)
 504:	6105                	addi	sp,sp,32
 506:	8082                	ret

0000000000000508 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 508:	7139                	addi	sp,sp,-64
 50a:	fc06                	sd	ra,56(sp)
 50c:	f822                	sd	s0,48(sp)
 50e:	f426                	sd	s1,40(sp)
 510:	0080                	addi	s0,sp,64
 512:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 514:	c299                	beqz	a3,51a <printint+0x12>
 516:	0805c963          	bltz	a1,5a8 <printint+0xa0>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 51a:	2581                	sext.w	a1,a1
  neg = 0;
 51c:	4881                	li	a7,0
 51e:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 522:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 524:	2601                	sext.w	a2,a2
 526:	00000517          	auipc	a0,0x0
 52a:	55a50513          	addi	a0,a0,1370 # a80 <digits>
 52e:	883a                	mv	a6,a4
 530:	2705                	addiw	a4,a4,1
 532:	02c5f7bb          	remuw	a5,a1,a2
 536:	1782                	slli	a5,a5,0x20
 538:	9381                	srli	a5,a5,0x20
 53a:	97aa                	add	a5,a5,a0
 53c:	0007c783          	lbu	a5,0(a5)
 540:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 544:	0005879b          	sext.w	a5,a1
 548:	02c5d5bb          	divuw	a1,a1,a2
 54c:	0685                	addi	a3,a3,1
 54e:	fec7f0e3          	bgeu	a5,a2,52e <printint+0x26>
  if(neg)
 552:	00088c63          	beqz	a7,56a <printint+0x62>
    buf[i++] = '-';
 556:	fd070793          	addi	a5,a4,-48
 55a:	00878733          	add	a4,a5,s0
 55e:	02d00793          	li	a5,45
 562:	fef70823          	sb	a5,-16(a4)
 566:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 56a:	02e05a63          	blez	a4,59e <printint+0x96>
 56e:	f04a                	sd	s2,32(sp)
 570:	ec4e                	sd	s3,24(sp)
 572:	fc040793          	addi	a5,s0,-64
 576:	00e78933          	add	s2,a5,a4
 57a:	fff78993          	addi	s3,a5,-1
 57e:	99ba                	add	s3,s3,a4
 580:	377d                	addiw	a4,a4,-1
 582:	1702                	slli	a4,a4,0x20
 584:	9301                	srli	a4,a4,0x20
 586:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 58a:	fff94583          	lbu	a1,-1(s2)
 58e:	8526                	mv	a0,s1
 590:	f5bff0ef          	jal	4ea <putc>
  while(--i >= 0)
 594:	197d                	addi	s2,s2,-1
 596:	ff391ae3          	bne	s2,s3,58a <printint+0x82>
 59a:	7902                	ld	s2,32(sp)
 59c:	69e2                	ld	s3,24(sp)
}
 59e:	70e2                	ld	ra,56(sp)
 5a0:	7442                	ld	s0,48(sp)
 5a2:	74a2                	ld	s1,40(sp)
 5a4:	6121                	addi	sp,sp,64
 5a6:	8082                	ret
    x = -xx;
 5a8:	40b005bb          	negw	a1,a1
    neg = 1;
 5ac:	4885                	li	a7,1
    x = -xx;
 5ae:	bf85                	j	51e <printint+0x16>

00000000000005b0 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 5b0:	711d                	addi	sp,sp,-96
 5b2:	ec86                	sd	ra,88(sp)
 5b4:	e8a2                	sd	s0,80(sp)
 5b6:	e0ca                	sd	s2,64(sp)
 5b8:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 5ba:	0005c903          	lbu	s2,0(a1)
 5be:	26090863          	beqz	s2,82e <vprintf+0x27e>
 5c2:	e4a6                	sd	s1,72(sp)
 5c4:	fc4e                	sd	s3,56(sp)
 5c6:	f852                	sd	s4,48(sp)
 5c8:	f456                	sd	s5,40(sp)
 5ca:	f05a                	sd	s6,32(sp)
 5cc:	ec5e                	sd	s7,24(sp)
 5ce:	e862                	sd	s8,16(sp)
 5d0:	e466                	sd	s9,8(sp)
 5d2:	8b2a                	mv	s6,a0
 5d4:	8a2e                	mv	s4,a1
 5d6:	8bb2                	mv	s7,a2
  state = 0;
 5d8:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 5da:	4481                	li	s1,0
 5dc:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 5de:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 5e2:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 5e6:	06c00c93          	li	s9,108
 5ea:	a005                	j	60a <vprintf+0x5a>
        putc(fd, c0);
 5ec:	85ca                	mv	a1,s2
 5ee:	855a                	mv	a0,s6
 5f0:	efbff0ef          	jal	4ea <putc>
 5f4:	a019                	j	5fa <vprintf+0x4a>
    } else if(state == '%'){
 5f6:	03598263          	beq	s3,s5,61a <vprintf+0x6a>
  for(i = 0; fmt[i]; i++){
 5fa:	2485                	addiw	s1,s1,1
 5fc:	8726                	mv	a4,s1
 5fe:	009a07b3          	add	a5,s4,s1
 602:	0007c903          	lbu	s2,0(a5)
 606:	20090c63          	beqz	s2,81e <vprintf+0x26e>
    c0 = fmt[i] & 0xff;
 60a:	0009079b          	sext.w	a5,s2
    if(state == 0){
 60e:	fe0994e3          	bnez	s3,5f6 <vprintf+0x46>
      if(c0 == '%'){
 612:	fd579de3          	bne	a5,s5,5ec <vprintf+0x3c>
        state = '%';
 616:	89be                	mv	s3,a5
 618:	b7cd                	j	5fa <vprintf+0x4a>
      if(c0) c1 = fmt[i+1] & 0xff;
 61a:	00ea06b3          	add	a3,s4,a4
 61e:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 622:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
 624:	c681                	beqz	a3,62c <vprintf+0x7c>
 626:	9752                	add	a4,a4,s4
 628:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
 62c:	03878f63          	beq	a5,s8,66a <vprintf+0xba>
      } else if(c0 == 'l' && c1 == 'd'){
 630:	05978963          	beq	a5,s9,682 <vprintf+0xd2>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
 634:	07500713          	li	a4,117
 638:	0ee78363          	beq	a5,a4,71e <vprintf+0x16e>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
 63c:	07800713          	li	a4,120
 640:	12e78563          	beq	a5,a4,76a <vprintf+0x1ba>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
 644:	07000713          	li	a4,112
 648:	14e78a63          	beq	a5,a4,79c <vprintf+0x1ec>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 's'){
 64c:	07300713          	li	a4,115
 650:	18e78a63          	beq	a5,a4,7e4 <vprintf+0x234>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
 654:	02500713          	li	a4,37
 658:	04e79563          	bne	a5,a4,6a2 <vprintf+0xf2>
        putc(fd, '%');
 65c:	02500593          	li	a1,37
 660:	855a                	mv	a0,s6
 662:	e89ff0ef          	jal	4ea <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
#endif
      state = 0;
 666:	4981                	li	s3,0
 668:	bf49                	j	5fa <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 1);
 66a:	008b8913          	addi	s2,s7,8
 66e:	4685                	li	a3,1
 670:	4629                	li	a2,10
 672:	000ba583          	lw	a1,0(s7)
 676:	855a                	mv	a0,s6
 678:	e91ff0ef          	jal	508 <printint>
 67c:	8bca                	mv	s7,s2
      state = 0;
 67e:	4981                	li	s3,0
 680:	bfad                	j	5fa <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'd'){
 682:	06400793          	li	a5,100
 686:	02f68963          	beq	a3,a5,6b8 <vprintf+0x108>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 68a:	06c00793          	li	a5,108
 68e:	04f68263          	beq	a3,a5,6d2 <vprintf+0x122>
      } else if(c0 == 'l' && c1 == 'u'){
 692:	07500793          	li	a5,117
 696:	0af68063          	beq	a3,a5,736 <vprintf+0x186>
      } else if(c0 == 'l' && c1 == 'x'){
 69a:	07800793          	li	a5,120
 69e:	0ef68263          	beq	a3,a5,782 <vprintf+0x1d2>
        putc(fd, '%');
 6a2:	02500593          	li	a1,37
 6a6:	855a                	mv	a0,s6
 6a8:	e43ff0ef          	jal	4ea <putc>
        putc(fd, c0);
 6ac:	85ca                	mv	a1,s2
 6ae:	855a                	mv	a0,s6
 6b0:	e3bff0ef          	jal	4ea <putc>
      state = 0;
 6b4:	4981                	li	s3,0
 6b6:	b791                	j	5fa <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 6b8:	008b8913          	addi	s2,s7,8
 6bc:	4685                	li	a3,1
 6be:	4629                	li	a2,10
 6c0:	000ba583          	lw	a1,0(s7)
 6c4:	855a                	mv	a0,s6
 6c6:	e43ff0ef          	jal	508 <printint>
        i += 1;
 6ca:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 6cc:	8bca                	mv	s7,s2
      state = 0;
 6ce:	4981                	li	s3,0
        i += 1;
 6d0:	b72d                	j	5fa <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 6d2:	06400793          	li	a5,100
 6d6:	02f60763          	beq	a2,a5,704 <vprintf+0x154>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 6da:	07500793          	li	a5,117
 6de:	06f60963          	beq	a2,a5,750 <vprintf+0x1a0>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 6e2:	07800793          	li	a5,120
 6e6:	faf61ee3          	bne	a2,a5,6a2 <vprintf+0xf2>
        printint(fd, va_arg(ap, uint64), 16, 0);
 6ea:	008b8913          	addi	s2,s7,8
 6ee:	4681                	li	a3,0
 6f0:	4641                	li	a2,16
 6f2:	000ba583          	lw	a1,0(s7)
 6f6:	855a                	mv	a0,s6
 6f8:	e11ff0ef          	jal	508 <printint>
        i += 2;
 6fc:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 6fe:	8bca                	mv	s7,s2
      state = 0;
 700:	4981                	li	s3,0
        i += 2;
 702:	bde5                	j	5fa <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 704:	008b8913          	addi	s2,s7,8
 708:	4685                	li	a3,1
 70a:	4629                	li	a2,10
 70c:	000ba583          	lw	a1,0(s7)
 710:	855a                	mv	a0,s6
 712:	df7ff0ef          	jal	508 <printint>
        i += 2;
 716:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 718:	8bca                	mv	s7,s2
      state = 0;
 71a:	4981                	li	s3,0
        i += 2;
 71c:	bdf9                	j	5fa <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 0);
 71e:	008b8913          	addi	s2,s7,8
 722:	4681                	li	a3,0
 724:	4629                	li	a2,10
 726:	000ba583          	lw	a1,0(s7)
 72a:	855a                	mv	a0,s6
 72c:	dddff0ef          	jal	508 <printint>
 730:	8bca                	mv	s7,s2
      state = 0;
 732:	4981                	li	s3,0
 734:	b5d9                	j	5fa <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 736:	008b8913          	addi	s2,s7,8
 73a:	4681                	li	a3,0
 73c:	4629                	li	a2,10
 73e:	000ba583          	lw	a1,0(s7)
 742:	855a                	mv	a0,s6
 744:	dc5ff0ef          	jal	508 <printint>
        i += 1;
 748:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 74a:	8bca                	mv	s7,s2
      state = 0;
 74c:	4981                	li	s3,0
        i += 1;
 74e:	b575                	j	5fa <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 750:	008b8913          	addi	s2,s7,8
 754:	4681                	li	a3,0
 756:	4629                	li	a2,10
 758:	000ba583          	lw	a1,0(s7)
 75c:	855a                	mv	a0,s6
 75e:	dabff0ef          	jal	508 <printint>
        i += 2;
 762:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 764:	8bca                	mv	s7,s2
      state = 0;
 766:	4981                	li	s3,0
        i += 2;
 768:	bd49                	j	5fa <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 16, 0);
 76a:	008b8913          	addi	s2,s7,8
 76e:	4681                	li	a3,0
 770:	4641                	li	a2,16
 772:	000ba583          	lw	a1,0(s7)
 776:	855a                	mv	a0,s6
 778:	d91ff0ef          	jal	508 <printint>
 77c:	8bca                	mv	s7,s2
      state = 0;
 77e:	4981                	li	s3,0
 780:	bdad                	j	5fa <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 16, 0);
 782:	008b8913          	addi	s2,s7,8
 786:	4681                	li	a3,0
 788:	4641                	li	a2,16
 78a:	000ba583          	lw	a1,0(s7)
 78e:	855a                	mv	a0,s6
 790:	d79ff0ef          	jal	508 <printint>
        i += 1;
 794:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 796:	8bca                	mv	s7,s2
      state = 0;
 798:	4981                	li	s3,0
        i += 1;
 79a:	b585                	j	5fa <vprintf+0x4a>
 79c:	e06a                	sd	s10,0(sp)
        printptr(fd, va_arg(ap, uint64));
 79e:	008b8d13          	addi	s10,s7,8
 7a2:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 7a6:	03000593          	li	a1,48
 7aa:	855a                	mv	a0,s6
 7ac:	d3fff0ef          	jal	4ea <putc>
  putc(fd, 'x');
 7b0:	07800593          	li	a1,120
 7b4:	855a                	mv	a0,s6
 7b6:	d35ff0ef          	jal	4ea <putc>
 7ba:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 7bc:	00000b97          	auipc	s7,0x0
 7c0:	2c4b8b93          	addi	s7,s7,708 # a80 <digits>
 7c4:	03c9d793          	srli	a5,s3,0x3c
 7c8:	97de                	add	a5,a5,s7
 7ca:	0007c583          	lbu	a1,0(a5)
 7ce:	855a                	mv	a0,s6
 7d0:	d1bff0ef          	jal	4ea <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 7d4:	0992                	slli	s3,s3,0x4
 7d6:	397d                	addiw	s2,s2,-1
 7d8:	fe0916e3          	bnez	s2,7c4 <vprintf+0x214>
        printptr(fd, va_arg(ap, uint64));
 7dc:	8bea                	mv	s7,s10
      state = 0;
 7de:	4981                	li	s3,0
 7e0:	6d02                	ld	s10,0(sp)
 7e2:	bd21                	j	5fa <vprintf+0x4a>
        if((s = va_arg(ap, char*)) == 0)
 7e4:	008b8993          	addi	s3,s7,8
 7e8:	000bb903          	ld	s2,0(s7)
 7ec:	00090f63          	beqz	s2,80a <vprintf+0x25a>
        for(; *s; s++)
 7f0:	00094583          	lbu	a1,0(s2)
 7f4:	c195                	beqz	a1,818 <vprintf+0x268>
          putc(fd, *s);
 7f6:	855a                	mv	a0,s6
 7f8:	cf3ff0ef          	jal	4ea <putc>
        for(; *s; s++)
 7fc:	0905                	addi	s2,s2,1
 7fe:	00094583          	lbu	a1,0(s2)
 802:	f9f5                	bnez	a1,7f6 <vprintf+0x246>
        if((s = va_arg(ap, char*)) == 0)
 804:	8bce                	mv	s7,s3
      state = 0;
 806:	4981                	li	s3,0
 808:	bbcd                	j	5fa <vprintf+0x4a>
          s = "(null)";
 80a:	00000917          	auipc	s2,0x0
 80e:	26e90913          	addi	s2,s2,622 # a78 <malloc+0x162>
        for(; *s; s++)
 812:	02800593          	li	a1,40
 816:	b7c5                	j	7f6 <vprintf+0x246>
        if((s = va_arg(ap, char*)) == 0)
 818:	8bce                	mv	s7,s3
      state = 0;
 81a:	4981                	li	s3,0
 81c:	bbf9                	j	5fa <vprintf+0x4a>
 81e:	64a6                	ld	s1,72(sp)
 820:	79e2                	ld	s3,56(sp)
 822:	7a42                	ld	s4,48(sp)
 824:	7aa2                	ld	s5,40(sp)
 826:	7b02                	ld	s6,32(sp)
 828:	6be2                	ld	s7,24(sp)
 82a:	6c42                	ld	s8,16(sp)
 82c:	6ca2                	ld	s9,8(sp)
    }
  }
}
 82e:	60e6                	ld	ra,88(sp)
 830:	6446                	ld	s0,80(sp)
 832:	6906                	ld	s2,64(sp)
 834:	6125                	addi	sp,sp,96
 836:	8082                	ret

0000000000000838 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 838:	715d                	addi	sp,sp,-80
 83a:	ec06                	sd	ra,24(sp)
 83c:	e822                	sd	s0,16(sp)
 83e:	1000                	addi	s0,sp,32
 840:	e010                	sd	a2,0(s0)
 842:	e414                	sd	a3,8(s0)
 844:	e818                	sd	a4,16(s0)
 846:	ec1c                	sd	a5,24(s0)
 848:	03043023          	sd	a6,32(s0)
 84c:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 850:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 854:	8622                	mv	a2,s0
 856:	d5bff0ef          	jal	5b0 <vprintf>
}
 85a:	60e2                	ld	ra,24(sp)
 85c:	6442                	ld	s0,16(sp)
 85e:	6161                	addi	sp,sp,80
 860:	8082                	ret

0000000000000862 <printf>:

void
printf(const char *fmt, ...)
{
 862:	711d                	addi	sp,sp,-96
 864:	ec06                	sd	ra,24(sp)
 866:	e822                	sd	s0,16(sp)
 868:	1000                	addi	s0,sp,32
 86a:	e40c                	sd	a1,8(s0)
 86c:	e810                	sd	a2,16(s0)
 86e:	ec14                	sd	a3,24(s0)
 870:	f018                	sd	a4,32(s0)
 872:	f41c                	sd	a5,40(s0)
 874:	03043823          	sd	a6,48(s0)
 878:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 87c:	00840613          	addi	a2,s0,8
 880:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 884:	85aa                	mv	a1,a0
 886:	4505                	li	a0,1
 888:	d29ff0ef          	jal	5b0 <vprintf>
}
 88c:	60e2                	ld	ra,24(sp)
 88e:	6442                	ld	s0,16(sp)
 890:	6125                	addi	sp,sp,96
 892:	8082                	ret

0000000000000894 <free>:
 894:	1141                	addi	sp,sp,-16
 896:	e422                	sd	s0,8(sp)
 898:	0800                	addi	s0,sp,16
 89a:	ff050693          	addi	a3,a0,-16
 89e:	00000797          	auipc	a5,0x0
 8a2:	7627b783          	ld	a5,1890(a5) # 1000 <freep>
 8a6:	a02d                	j	8d0 <free+0x3c>
 8a8:	4618                	lw	a4,8(a2)
 8aa:	9f2d                	addw	a4,a4,a1
 8ac:	fee52c23          	sw	a4,-8(a0)
 8b0:	6398                	ld	a4,0(a5)
 8b2:	6310                	ld	a2,0(a4)
 8b4:	a83d                	j	8f2 <free+0x5e>
 8b6:	ff852703          	lw	a4,-8(a0)
 8ba:	9f31                	addw	a4,a4,a2
 8bc:	c798                	sw	a4,8(a5)
 8be:	ff053683          	ld	a3,-16(a0)
 8c2:	a091                	j	906 <free+0x72>
 8c4:	6398                	ld	a4,0(a5)
 8c6:	00e7e463          	bltu	a5,a4,8ce <free+0x3a>
 8ca:	00e6ea63          	bltu	a3,a4,8de <free+0x4a>
 8ce:	87ba                	mv	a5,a4
 8d0:	fed7fae3          	bgeu	a5,a3,8c4 <free+0x30>
 8d4:	6398                	ld	a4,0(a5)
 8d6:	00e6e463          	bltu	a3,a4,8de <free+0x4a>
 8da:	fee7eae3          	bltu	a5,a4,8ce <free+0x3a>
 8de:	ff852583          	lw	a1,-8(a0)
 8e2:	6390                	ld	a2,0(a5)
 8e4:	02059813          	slli	a6,a1,0x20
 8e8:	01c85713          	srli	a4,a6,0x1c
 8ec:	9736                	add	a4,a4,a3
 8ee:	fae60de3          	beq	a2,a4,8a8 <free+0x14>
 8f2:	fec53823          	sd	a2,-16(a0)
 8f6:	4790                	lw	a2,8(a5)
 8f8:	02061593          	slli	a1,a2,0x20
 8fc:	01c5d713          	srli	a4,a1,0x1c
 900:	973e                	add	a4,a4,a5
 902:	fae68ae3          	beq	a3,a4,8b6 <free+0x22>
 906:	e394                	sd	a3,0(a5)
 908:	00000717          	auipc	a4,0x0
 90c:	6ef73c23          	sd	a5,1784(a4) # 1000 <freep>
 910:	6422                	ld	s0,8(sp)
 912:	0141                	addi	sp,sp,16
 914:	8082                	ret

0000000000000916 <malloc>:
 916:	7139                	addi	sp,sp,-64
 918:	fc06                	sd	ra,56(sp)
 91a:	f822                	sd	s0,48(sp)
 91c:	f426                	sd	s1,40(sp)
 91e:	ec4e                	sd	s3,24(sp)
 920:	0080                	addi	s0,sp,64
 922:	02051493          	slli	s1,a0,0x20
 926:	9081                	srli	s1,s1,0x20
 928:	04bd                	addi	s1,s1,15
 92a:	8091                	srli	s1,s1,0x4
 92c:	0014899b          	addiw	s3,s1,1
 930:	0485                	addi	s1,s1,1
 932:	00000517          	auipc	a0,0x0
 936:	6ce53503          	ld	a0,1742(a0) # 1000 <freep>
 93a:	c915                	beqz	a0,96e <malloc+0x58>
 93c:	611c                	ld	a5,0(a0)
 93e:	4798                	lw	a4,8(a5)
 940:	08977a63          	bgeu	a4,s1,9d4 <malloc+0xbe>
 944:	f04a                	sd	s2,32(sp)
 946:	e852                	sd	s4,16(sp)
 948:	e456                	sd	s5,8(sp)
 94a:	e05a                	sd	s6,0(sp)
 94c:	8a4e                	mv	s4,s3
 94e:	0009871b          	sext.w	a4,s3
 952:	6685                	lui	a3,0x1
 954:	00d77363          	bgeu	a4,a3,95a <malloc+0x44>
 958:	6a05                	lui	s4,0x1
 95a:	000a0b1b          	sext.w	s6,s4
 95e:	004a1a1b          	slliw	s4,s4,0x4
 962:	00000917          	auipc	s2,0x0
 966:	69e90913          	addi	s2,s2,1694 # 1000 <freep>
 96a:	5afd                	li	s5,-1
 96c:	a081                	j	9ac <malloc+0x96>
 96e:	f04a                	sd	s2,32(sp)
 970:	e852                	sd	s4,16(sp)
 972:	e456                	sd	s5,8(sp)
 974:	e05a                	sd	s6,0(sp)
 976:	00000797          	auipc	a5,0x0
 97a:	69a78793          	addi	a5,a5,1690 # 1010 <base>
 97e:	00000717          	auipc	a4,0x0
 982:	68f73123          	sd	a5,1666(a4) # 1000 <freep>
 986:	e39c                	sd	a5,0(a5)
 988:	0007a423          	sw	zero,8(a5)
 98c:	b7c1                	j	94c <malloc+0x36>
 98e:	6398                	ld	a4,0(a5)
 990:	e118                	sd	a4,0(a0)
 992:	a8a9                	j	9ec <malloc+0xd6>
 994:	01652423          	sw	s6,8(a0)
 998:	0541                	addi	a0,a0,16
 99a:	efbff0ef          	jal	894 <free>
 99e:	00093503          	ld	a0,0(s2)
 9a2:	c12d                	beqz	a0,a04 <malloc+0xee>
 9a4:	611c                	ld	a5,0(a0)
 9a6:	4798                	lw	a4,8(a5)
 9a8:	02977263          	bgeu	a4,s1,9cc <malloc+0xb6>
 9ac:	00093703          	ld	a4,0(s2)
 9b0:	853e                	mv	a0,a5
 9b2:	fef719e3          	bne	a4,a5,9a4 <malloc+0x8e>
 9b6:	8552                	mv	a0,s4
 9b8:	af3ff0ef          	jal	4aa <sbrk>
 9bc:	fd551ce3          	bne	a0,s5,994 <malloc+0x7e>
 9c0:	4501                	li	a0,0
 9c2:	7902                	ld	s2,32(sp)
 9c4:	6a42                	ld	s4,16(sp)
 9c6:	6aa2                	ld	s5,8(sp)
 9c8:	6b02                	ld	s6,0(sp)
 9ca:	a03d                	j	9f8 <malloc+0xe2>
 9cc:	7902                	ld	s2,32(sp)
 9ce:	6a42                	ld	s4,16(sp)
 9d0:	6aa2                	ld	s5,8(sp)
 9d2:	6b02                	ld	s6,0(sp)
 9d4:	fae48de3          	beq	s1,a4,98e <malloc+0x78>
 9d8:	4137073b          	subw	a4,a4,s3
 9dc:	c798                	sw	a4,8(a5)
 9de:	02071693          	slli	a3,a4,0x20
 9e2:	01c6d713          	srli	a4,a3,0x1c
 9e6:	97ba                	add	a5,a5,a4
 9e8:	0137a423          	sw	s3,8(a5)
 9ec:	00000717          	auipc	a4,0x0
 9f0:	60a73a23          	sd	a0,1556(a4) # 1000 <freep>
 9f4:	01078513          	addi	a0,a5,16
 9f8:	70e2                	ld	ra,56(sp)
 9fa:	7442                	ld	s0,48(sp)
 9fc:	74a2                	ld	s1,40(sp)
 9fe:	69e2                	ld	s3,24(sp)
 a00:	6121                	addi	sp,sp,64
 a02:	8082                	ret
 a04:	7902                	ld	s2,32(sp)
 a06:	6a42                	ld	s4,16(sp)
 a08:	6aa2                	ld	s5,8(sp)
 a0a:	6b02                	ld	s6,0(sp)
 a0c:	b7f5                	j	9f8 <malloc+0xe2>
