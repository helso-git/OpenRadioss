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
Chd|  HM_READ_ALE_MUSCL             source/general_controls/ale_cfd/hm_read_ale_muscl.F
Chd|-- called by -----------
Chd|        CONTRL                        source/starter/contrl.F       
Chd|-- calls ---------------
Chd|        ANCMSG                        source/output/message/message.F
Chd|        HM_GET_FLOATV                 source/devtools/hm_reader/hm_get_floatv.F
Chd|        HM_GET_INTV                   source/devtools/hm_reader/hm_get_intv.F
Chd|        HM_OPTION_COUNT               source/devtools/hm_reader/hm_option_count.F
Chd|        HM_OPTION_NEXT                source/devtools/hm_reader/hm_option_next.F
Chd|        HM_OPTION_START               source/devtools/hm_reader/hm_option_start.F
Chd|        ALEMUSCL_MOD                  ../common_source/modules/ale/alemuscl_mod.F
Chd|        HM_OPTION_READ_MOD            share/modules1/hm_option_read_mod.F
Chd|        MESSAGE_MOD                   share/message_module/message_mod.F
Chd|        SUBMODEL_MOD                  share/modules1/submodel_mod.F 
Chd|====================================================================
      SUBROUTINE HM_READ_ALE_MUSCL(LSUBMODEL, UNITAB)
C-----------------------------------------------
C   D e s c r i p t i o n
C-----------------------------------------------
C This subroutine is reading /ALE/MUSCL option in user input file
C-----------------------------------------------
C   M o d u l e s
C-----------------------------------------------
      USE UNITAB_MOD
      USE HM_OPTION_READ_MOD
      USE SUBMODEL_MOD
      USE MESSAGE_MOD
      USE ALEMUSCL_MOD , only : ALEMUSCL_Param
C-----------------------------------------------
C   I m p l i c i t   T y p e s
C-----------------------------------------------
#include "implicit_f.inc"
C-----------------------------------------------
C   C o m m o n   B l o c k s
C-----------------------------------------------
#include "submod_c.inc"
#include "scr05_c.inc"
C-----------------------------------------------
C   D u m m y   A r g u m e n t s
C-----------------------------------------------
      TYPE(SUBMODEL_DATA), DIMENSION(NSUBMOD), INTENT(IN) :: LSUBMODEL
      TYPE(UNIT_TYPE_), INTENT(IN) :: UNITAB
C-----------------------------------------------
C   L o c a l   V a r i a b l e s
C-----------------------------------------------     
      INTEGER :: NALEMUSCL,IALEMUSCL
      LOGICAL :: IS_AVAILABLE
      my_real :: BETA
C-----------------------------------------------
C   S o u r c e   L i n e s
C-----------------------------------------------       
      CALL HM_OPTION_COUNT('/ALE/MUSCL', NALEMUSCL)
      
      IF (NALEMUSCL > 0) THEN
         CALL HM_OPTION_START('/ALE/MUSCL')
         CALL HM_OPTION_NEXT()
         CALL HM_GET_FLOATV('ALE_MUSCL_BETA', BETA, IS_AVAILABLE, LSUBMODEL, UNITAB)
         CALL HM_GET_INTV('MAT_Iflag', IALEMUSCL, IS_AVAILABLE, LSUBMODEL)
         
         !---default BETA
         IF (BETA == ZERO) THEN
           BETA = TWO
         ENDIF

         !---default IALEMUSCL
         IF (IALEMUSCL == 0) THEN
           IALEMUSCL = 1
         ELSEIF (IALEMUSCL == 1) THEN
           IALEMUSCL = 2
         ELSEIF (IALEMUSCL < -1 .OR. IALEMUSCL >= 2) THEN
           IALEMUSCL = 1
         ENDIF
                  
         !---MUSCL off / disabled
         IF(IALEMUSCL == -1)THEN
           IALEMUSCL = 0
           BETA = TWO
           NALEMUSCL=0
         ENDIF
         
         ALEMUSCL_Param%IALEMUSCL = IALEMUSCL
         ALEMUSCL_Param%Beta = BETA
         
         IF (IRESP == 1) THEN
            ! Not available in single precision
            CALL ANCMSG(MSGID = 1563, ANMODE = ANINFO, MSGTYPE = MSGERROR)
         ENDIF
      ENDIF
C-----------------------------------------------
      END SUBROUTINE HM_READ_ALE_MUSCL
