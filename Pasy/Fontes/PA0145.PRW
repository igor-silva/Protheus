#include "rwmake.ch"
#INCLUDE "TOPCONN.CH"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �PA0145    �Autor  �Alexandro da Silva  � Data �  22/10/07   ���
�������������������������������������������������������������������������͹��
���Desc.     � Traz o total do bordero no programa FINA060                ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � SIGAFIN                                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/


User Function PA0145()


_aAliOri  := GetArea()                   
FA060NUMC()

_cQ := " SELECT E1_NUMBOR,SUM(E1_VALOR) AS VALOR  FROM "+RetSqlName("SE1")+" E1 "
_cQ += " WHERE E1_NUMBOR = '"+MV_PAR01+"' AND E1.D_E_L_E_T_ = '' "
_cQ += " GROUP BY E1_NUMBOR "
     
TCQUERY _cQ NEW ALIAS "TRB"

Alert("VALOR DO BORDERO PARA ESTORNO : "+Alltrim(Str(TRB->VALOR)))

TRB->(dbCloseArea())

RestArea(_aAliOri)

Return