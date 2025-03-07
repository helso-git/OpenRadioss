Copyright>        OpenRadioss
Copyright>        Copyright (C) 1986-2023 Altair Engineering Inc.
Copyright>
Copyright>        This program is free software: you can redistribute it and/or modify
Copyright>        it under the terms of the GNU Affero General Public License as published by
Copyright>        the Free Software Foundation, either version 3 of the License, or
Copyright>        (at your option) any later version.
Copyright>
Copyright>        This program is distributed in the hope that it will be useful,
Copyright>        but WITHOUT ANY WARRANTY; without even the implied warranty of
Copyright>        MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
Copyright>        GNU Affero General Public License for more details.
Copyright>
Copyright>        You should have received a copy of the GNU Affero General Public License
Copyright>        along with this program.  If not, see <https://www.gnu.org/licenses/>.
Copyright>
Copyright>
Copyright>        Commercial Alternative: Altair Radioss Software
Copyright>
Copyright>        As an alternative to this open-source version, Altair also offers Altair Radioss
Copyright>        software under a commercial license.  Contact Altair to discuss further if the
Copyright>        commercial version may interest you: https://www.altair.com/radioss/.
Chd|====================================================================
Chd|  STAT_QUAD_SPMD                source/output/sta/stat_quad_spmd.F
Chd|-- called by -----------
Chd|        GENSTAT                       source/output/sta/genstat.F   
Chd|-- calls ---------------
Chd|        ELBUFDEF_MOD                  ../common_source/modules/mat_elem/elbufdef_mod.F
Chd|====================================================================
      SUBROUTINE STAT_QUAD_SPMD(ITAB,IPART,IGEO,IXQ,IPARTQ,
     .                     IPART_STATE,NODTAG,STAT_INDXQ,
     .                     IPARG, LENGQ, ELBUF_TAB )
C-----------------------------------------------
C   M o d u l e s
C-----------------------------------------------
      USE ELBUFDEF_MOD 
C-----------------------------------------------
C   I m p l i c i t   T y p e s
C-----------------------------------------------
#include      "implicit_f.inc"
C-----------------------------------------------
C   C o m m o n   B l o c k s
C-----------------------------------------------
#include      "com01_c.inc"
#include      "com04_c.inc"
#include      "param_c.inc"
#include      "scr17_c.inc"
#include      "spmd_c.inc"
C-----------------------------------------------
C   D u m m y   A r g u m e n t s
C-----------------------------------------------
      INTEGER ITAB(*), IPART(LIPART1,*),
     .        IGEO(NPROPGI,*), IXQ(NIXQ,*),
     .        IPARTQ(*), IPART_STATE(*),
     .        NODTAG(*), STAT_INDXQ(*),
     .        IPARG(NPARG,*),LENGQ,IDEL
      TYPE (ELBUF_STRUCT_), DIMENSION(NGROUP), TARGET :: ELBUF_TAB
C-----------------------------------------------
C   L o c a l   V a r i a b l e s
C-----------------------------------------------
      INTEGER I, N, JJ, IPRT, BUF, IPRT0, K, STAT_NUMELQ_1
      INTEGER NG, NEL, NFT, LFT, LLT, ITY, ISOLNOD, IOFF
      INTEGER IADD(NPART+1), IADG(NSPMD,NPART)
      INTEGER NP(24*NUMELQG),
     .        NPGLOB(24*NUMELQG),
     .        WORK(70000),CLEF(2,NUMELQG)
      TYPE(G_BUFEL_)  ,POINTER :: GBUF     
C-----------------------------------------------
C     8 NODES BRICK
C-----------------------------------------------
      JJ = 0
      DO NG=1,NGROUP
        ITY   =IPARG(5,NG)
        ISOLNOD = IPARG(28,NG)
        NEL   =IPARG(2,NG)
        NFT   =IPARG(3,NG)
        GBUF => ELBUF_TAB(NG)%GBUF   
        LFT=1
        LLT=NEL
        IF(ITY == 2) THEN
         DO I=LFT,LLT
          N  = I + NFT

          IPRT=IPARTQ(N)
          IF(IPART_STATE(IPRT)==0)CYCLE


            NODTAG(IXQ(2,N))=1
            NODTAG(IXQ(3,N))=1
            NODTAG(IXQ(4,N))=1
            NODTAG(IXQ(5,N))=1

       
         END DO
       END IF
      END DO

C-----------------------------------------------
      RETURN
      END
