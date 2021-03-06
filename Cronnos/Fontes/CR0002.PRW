#include "rwmake.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �CR0002                                 � Data �  17/08/07   ���
�������������������������������������������������������������������������͹��
���Desc.     � Gatilho para gerar numero autom�tico no Contas a Pagar     ���
���          � Quando o Tipo for ND ou CI                                 ���
�������������������������������������������������������������������������͹��
���Uso       � MP8                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function CR0002()

_cAliOri := Alias()
_nOrdORI := IndexOrd()
_nRecORI := Recno()

_cTipo    := ""
_cNum     := ""

dbSelectArea("SE2")

_cAliSE2 := Alias()
_nOrdSE2 := IndexOrd()
_nRecSE2 := Recno()

dbOrderNickname("INDSE21")
If dbSeek(xFilial()+M->E2_TIPO)

   _cTipo := SE2->E2_TIPO

   While !Eof() .And. _cTipo == SE2->E2_TIPO

      _cNum := SE2->E2_NUM

      dbSeLectArea("SE2")
      dbSkip()
   EndDo
Endif

_cNum := strzero((Val(_cNum)+1),6)

dbSelectArea(_cAliSE2)
dbSetOrder(_nOrdSE2)
dbGoto(_nRecSE2)

dbSelectArea(_cAliORI)
dbSetOrder(_nOrdORI)
dbGoto(_nRecORI)

Return(_cNum)
