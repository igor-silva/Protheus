#INCLUDE "rwmake.ch"

/*/
����������������������������������������������������������������������������
����������������������������������������������������������������������������
������������������������������������������������������������������������Ŀ��
���Programa  � Mta010Ok� Autor �Alexandro da Silva     � Data � 03/07/02 ���
������������������������������������������������������������������������Ĵ��
���Descri��o � Nao deixa excluir Produto cadastrado Produtox Cliente     ���
������������������������������������������������������������������������Ĵ��
���Uso       � Sigafat                                                   ���
�������������������������������������������������������������������������ٱ�
����������������������������������������������������������������������������
����������������������������������������������������������������������������

/*/

User Function Mta010Ok ()

_aAliOri := GetArea()

dbSelectArea("SZ2")
_aAliSZ2 := GetArea()
dbSetOrder(2)
If dbSeek(xFilial()+SB1->B1_COD)
   MsgBox ("Exclua Produto do Cadastro de Cliente x Produto !","Informacao","INFO")
   RestArea(_aAliSZ2)
   RestArea(_aAliOri)   
   Return (.F.)
Endif

RestArea(_aAliSZ2)
RestArea(_aAliOri)   

Return(.T.)
