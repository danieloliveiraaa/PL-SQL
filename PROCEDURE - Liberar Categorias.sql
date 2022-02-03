PROCEDURE SP_LIBERA_CATVFRETE (P_USUARIO           TDVADM.T_USU_APLICACAOPERFIL.USU_USUARIO_CODIGO%TYPE,
                               P_CATEGORIA_NUMERO  IN NUMBER,
                               P_MENSAGEM          OUT VARCHAR2)

/*

--CREATE BY DANIEL OLIVEIRA
--17/01/2021
--PROCEDURE PARA LIBERAR CATEGORIAS NO VALE FRETE
--CATVFRETE - Categorias de vale de frete, para um grupo de usuarios especificos.

1- UMA VIAGEM         | 6- TRANSPESA            | 11- MANIFESTO          | 16- VIAGEM CTRC s/ Placa
2- VARIAS VIAGENS     | 7- REMOÇÃO              | 12- AVULSO TERCEIRO    | 17- ESTADIA
3- TOMBO              | 8- AVULSO (DESPESA TDV) | 13- BÔNUS MANIFESTO    | 18- COLETA
4- REFORÇO            | 9- AVULSO COM CTRC      | 14- BÔNUS CTRC         | 19- OPERAÇÕES COM CTRC
5- COMPLEMENTO        | 10-SERVIÇO DE TERCEIRO  | 15- OPERAÇÃO COCA-COLA | 20- ENTREGA DE COLETEIRO

USU_APLICACAOPERFIL_PARAT = SSSSSSSSSSSSSSSSSSSS

CADA 'S' REPRESENTA QUE O USUARIO TEM AS CATEGORIAS ACIMA, LIBERADA.

*/

AS

   V_USUARIO_EXISTE NUMBER;

   V_CATVFRETE_LIBERADO NUMBER;
   
   V_AUX NUMBER;


BEGIN

    --VERIFICANDO SE O USUARIO DIGITADO EXISTE
    SELECT COUNT(*)
      INTO V_USUARIO_EXISTE
      FROM TDVADM.T_USU_APLICACAOPERFIL AP
     WHERE TRIM(AP.USU_USUARIO_CODIGO) = TRIM(P_USUARIO);



   --SE O COUNT ACIMA FOR MAIOR QUE 0
   --PARA EXECUÇÃO.
   IF (V_USUARIO_EXISTE = 0) THEN

     P_MENSAGEM := 'USUÁRIO INEXISTENTE, POR FAVOR DIGITE UM USUÁRIO VÁLIDO.';


   ELSE --(V_USUARIO_EXISTE > 0) THEN


       --VERIFICANDO SE O
       --O USUARIO TEM O PARÊMETRO
       --LIBERADO CATVFRETE NO USUARIO DELE.
       SELECT COUNT(*)
         INTO V_CATVFRETE_LIBERADO
         FROM TDVADM.T_USU_APLICACAOPERFIL AP1
        WHERE TRIM(AP1.USU_PERFIL_CODIGO)  = 'CATVFRETE'
          AND TRIM(AP1.USU_USUARIO_CODIGO) = TRIM(P_USUARIO);




        --SE ELE NAO TIVER O PARAMETRO 'CATVFRETE'
        --INSIRO ELE SEM NENHUMA CATEGORIA NO CASO 'SNNNNNNNNNSSSSSNSSNN'

          IF (V_CATVFRETE_LIBERADO = 0) THEN

             INSERT INTO TDVADM.T_USU_APLICACAOPERFIL AP3(AP3.USU_APLICACAO_CODIGO,
                                                          AP3.USU_PERFIL_CODIGO,
                                                          AP3.USU_USUARIO_CODIGO,
                                                          AP3.USU_GRUPO_CODIGO,
                                                          AP3.GLB_ROTA_CODIGO,
                                                          AP3.USU_APLICACAOPERFIL_DESCRICAO,
                                                          AP3.USU_APLICACAOPERFIL_QUENALTSA,
                                                          AP3.USU_APLICACAOPERFIL_ATIVO,
                                                          AP3.USU_APLICACAOPERFIL_VIGENCIA,
                                                          AP3.USU_APLICACAOPERFIL_VALIDADE,
                                                          AP3.USU_APLICACAOPERFIL_DTCAD,
                                                          AP3.USU_USUARIO_CODIGOCAD,
                                                          AP3.USU_APLICACAOPERFIL_DTALT,
                                                          AP3.USU_USUARIO_CODIGOALT,
                                                          AP3.USU_APLICACAOPERFIL_PARAT,
                                                          AP3.USU_APLICACAOPERFIL_PARAN1,
                                                          AP3.USU_APLICACAOPERFIL_PARAN2,
                                                          AP3.USU_APLICACAOPERFIL_PARAD1,
                                                          AP3.USU_APLICACAOPERFIL_PARAD2,
                                                          AP3.USU_TIPOUSU_CODIGO,
                                                          AP3.USU_APLICACAOPERFIL_HORARIO,
                                                          AP3.USU_APLICACAOPERFIL_PARAN3,
                                                          AP3.USU_APLICACAOPERFIL_PARAN4,
                                                          AP3.USU_APLICACAOPERFIL_PARAN5,
                                                          AP3.USU_APLICACAOPERFIL_PARAD3,
                                                          AP3.USU_APLICACAOPERFIL_PARAD4,
                                                          AP3.USU_APLICACAOPERFIL_PARAN6)

                                                      VALUES ('comvlfrete',
                                                              'CATVFRETE',
                                                              P_USUARIO,
                                                              '00000',
                                                              '000',
                                                              'Categorias de vale de frete, para um grupo de usuarios especificos.',
                                                              'C',
                                                              'S',
                                                              SYSDATE,
                                                              SYSDATE + 100000,
                                                              SYSDATE,
                                                              'jsantos',
                                                              SYSDATE,
                                                              'jsantos',
                                                              'SNNNNNNNNNSSSSSNSSNN', --Cateogrias default
                                                              NULL,
                                                              NULL,
                                                              NULL,
                                                              NULL,
                                                              'TDV',
                                                              'SSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSS',
                                                              NULL,
                                                              NULL,
                                                              NULL,
                                                              NULL,
                                                              NULL,
                                                              NULL);
                                                              
          
                   
          END IF;

    --VERIFICO AS LIBERAÇÕES QUE ELE JA TEM...
    --EX: SNSSSSSSSNNSSNNSSSSN

    --LIBERO AS CATEGORIAS NO VALE FRETE,
    --DE ACORDO COM O NUMERO INFORMADO.
    --EX: 1- UMA VIAGEM
    --MANTENHO AS LIBERAÇÕES QUE ELE JÁ POSSUIA.


    CASE P_CATEGORIA_NUMERO

      --UMA VIAGEM
      WHEN 1 THEN

      /*
         SELECT COUNT (*)
           INTO V_AUX
           FROM TDVADM.T_USU_APLICACAOPERFIL AP
          WHERE 0 = 0
            AND TRIM(AP.USU_USUARIO_CODIGO)  = TRIM(P_USUARIO)
            AND TRIM(AP.USU_PERFIL_CODIGO)   = 'CATVFRETE'     
            AND AP.USU_APLICACAOPERFIL_PARAT = 'S' || SUBSTR(AP.USU_APLICACAOPERFIL_PARAT,2,20);
            
         IF()THEN
         END IF;
       */
         
         
         UPDATE TDVADM.T_USU_APLICACAOPERFIL AP                                                        --SE O PARAMETRO ESTIVER
            SET AP.USU_APLICACAOPERFIL_PARAT       = 'S' || SUBSTR(AP.USU_APLICACAOPERFIL_PARAT,2,20)  --'NNNNNNNNNNNNNNNNNNNN'
          WHERE TRIM(AP.USU_USUARIO_CODIGO)        = TRIM(P_USUARIO)                                   --APOS ESSA LINHA IRÁ FICAR
            AND TRIM(AP.USU_PERFIL_CODIGO)         = 'CATVFRETE';                                      --'SNNNNNNNNNNNNNNNNNNN'

            COMMIT;

            P_MENSAGEM := 'LIBERADO UMA VIAGEM.';
            
            
      --VARIAS VIAGENS
      WHEN 2 THEN

         UPDATE TDVADM.T_USU_APLICACAOPERFIL AP
            SET AP.USU_APLICACAOPERFIL_PARAT       = SUBSTR(AP.USU_APLICACAOPERFIL_PARAT,1,1) || 'S' || SUBSTR(AP.USU_APLICACAOPERFIL_PARAT,3,20)
          WHERE TRIM(AP.USU_USUARIO_CODIGO)        = TRIM(P_USUARIO)                                   
            AND TRIM(AP.USU_PERFIL_CODIGO)         = 'CATVFRETE'; 

            COMMIT;

            P_MENSAGEM := 'LIBERADO VARIAS VIAGENS.';

      --TOMBO
      WHEN 3 THEN

         UPDATE TDVADM.T_USU_APLICACAOPERFIL AP
            SET AP.USU_APLICACAOPERFIL_PARAT       = SUBSTR(AP.USU_APLICACAOPERFIL_PARAT,1,2) || 'S' || SUBSTR(AP.USU_APLICACAOPERFIL_PARAT,4,20)
          WHERE TRIM(AP.USU_USUARIO_CODIGO)        = TRIM(P_USUARIO)                                   
            AND TRIM(AP.USU_PERFIL_CODIGO)         = 'CATVFRETE'; 

            COMMIT;

            P_MENSAGEM := 'LIBERADO TOMBO.';

      --REFORÇO
      WHEN 4 THEN

         UPDATE TDVADM.T_USU_APLICACAOPERFIL AP
            SET AP.USU_APLICACAOPERFIL_PARAT       = SUBSTR(AP.USU_APLICACAOPERFIL_PARAT,1,3) || 'S' || SUBSTR(AP.USU_APLICACAOPERFIL_PARAT,5,20)
          WHERE TRIM(AP.USU_USUARIO_CODIGO)        = TRIM(P_USUARIO)                                   
            AND TRIM(AP.USU_PERFIL_CODIGO)         = 'CATVFRETE'; 

            COMMIT;

            P_MENSAGEM := 'LIBERADO REFORÇO.';

      --COMPLEMENTO
      WHEN 5 THEN

         UPDATE TDVADM.T_USU_APLICACAOPERFIL AP
            SET AP.USU_APLICACAOPERFIL_PARAT       = SUBSTR(AP.USU_APLICACAOPERFIL_PARAT,1,4) || 'S' || SUBSTR(AP.USU_APLICACAOPERFIL_PARAT,6,20)
          WHERE TRIM(AP.USU_USUARIO_CODIGO)        = TRIM(P_USUARIO)                                   
            AND TRIM(AP.USU_PERFIL_CODIGO)         = 'CATVFRETE'; 

            COMMIT;

            P_MENSAGEM := 'LIBERADO COMPLEMENTO.';

      --TRANSPESA
      WHEN 6 THEN

         UPDATE TDVADM.T_USU_APLICACAOPERFIL AP
            SET AP.USU_APLICACAOPERFIL_PARAT       = SUBSTR(AP.USU_APLICACAOPERFIL_PARAT,1,5) || 'S' || SUBSTR(AP.USU_APLICACAOPERFIL_PARAT,7,20)
          WHERE TRIM(AP.USU_USUARIO_CODIGO)        = TRIM(P_USUARIO)                                   
            AND TRIM(AP.USU_PERFIL_CODIGO)         = 'CATVFRETE'; 

            COMMIT;

            P_MENSAGEM := 'LIBERADO TRANSPESA.';

      --REMOÇÃO
      WHEN 7 THEN

         UPDATE TDVADM.T_USU_APLICACAOPERFIL AP
            SET AP.USU_APLICACAOPERFIL_PARAT       = SUBSTR(AP.USU_APLICACAOPERFIL_PARAT,1,6) || 'S' || SUBSTR(AP.USU_APLICACAOPERFIL_PARAT,8,20)
          WHERE TRIM(AP.USU_USUARIO_CODIGO)        = TRIM(P_USUARIO)                                   
            AND TRIM(AP.USU_PERFIL_CODIGO)         = 'CATVFRETE'; 

            COMMIT;

            P_MENSAGEM := 'LIBERADO REMOÇÃO.';

      --AVULSO(DESPESA TDV)
      WHEN 8 THEN
         
         /*
         UPDATE TDVADM.T_USU_APLICACAOPERFIL AP
            SET AP.USU_APLICACAOPERFIL_PARAT       = SUBSTR(AP.USU_APLICACAOPERFIL_PARAT,1,7) || 'S' || SUBSTR(AP.USU_APLICACAOPERFIL_PARAT,9,20)
          WHERE TRIM(AP.USU_USUARIO_CODIGO)        = TRIM(P_USUARIO)                                   
            AND TRIM(AP.USU_PERFIL_CODIGO)         = 'CATVFRETE'; 

            COMMIT;
         */
            P_MENSAGEM := 'NECESSÁRIO AUTORIZAÇÃO DO RICARDO CARVALHO OU JOSÉ MOREIRA !';
            

      --AVULSO COM CTRC
      WHEN 9 THEN
         
         /*
         UPDATE TDVADM.T_USU_APLICACAOPERFIL AP
            SET AP.USU_APLICACAOPERFIL_PARAT       = SUBSTR(AP.USU_APLICACAOPERFIL_PARAT,1,8) || 'S' || SUBSTR(AP.USU_APLICACAOPERFIL_PARAT,10,20)
          WHERE TRIM(AP.USU_USUARIO_CODIGO)        = TRIM(P_USUARIO)                                   
            AND TRIM(AP.USU_PERFIL_CODIGO)         = 'CATVFRETE'; 

         COMMIT;
         */
            P_MENSAGEM := 'NECESSÁRIO AUTORIZAÇÃO DO RICARDO CARVALHO OU JOSÉ MOREIRA !';
            

      --SERVIÇO DE TERCEIRO
      WHEN 10 THEN

         UPDATE TDVADM.T_USU_APLICACAOPERFIL AP
            SET AP.USU_APLICACAOPERFIL_PARAT       = SUBSTR(AP.USU_APLICACAOPERFIL_PARAT,1,9) || 'S' || SUBSTR(AP.USU_APLICACAOPERFIL_PARAT,11,20)
          WHERE TRIM(AP.USU_USUARIO_CODIGO)        = TRIM(P_USUARIO)                                   
            AND TRIM(AP.USU_PERFIL_CODIGO)         = 'CATVFRETE'; 

            COMMIT;

            P_MENSAGEM := 'LIBERADO SERVIÇO DE TERCEIRO.';

      --MANIFESTO
      WHEN 11 THEN

         UPDATE TDVADM.T_USU_APLICACAOPERFIL AP
            SET AP.USU_APLICACAOPERFIL_PARAT       = SUBSTR(AP.USU_APLICACAOPERFIL_PARAT,1,10) || 'S' || SUBSTR(AP.USU_APLICACAOPERFIL_PARAT,12,20)
          WHERE TRIM(AP.USU_USUARIO_CODIGO)        = TRIM(P_USUARIO)                                   
            AND TRIM(AP.USU_PERFIL_CODIGO)         = 'CATVFRETE'; 

            COMMIT;

            P_MENSAGEM := 'LIBERADO MANIFESTO.';

      --AVULSO TERCEIRO
      WHEN 12 THEN

         UPDATE TDVADM.T_USU_APLICACAOPERFIL AP
            SET AP.USU_APLICACAOPERFIL_PARAT       = SUBSTR(AP.USU_APLICACAOPERFIL_PARAT,1,11) || 'S' || SUBSTR(AP.USU_APLICACAOPERFIL_PARAT,13,20)
          WHERE TRIM(AP.USU_USUARIO_CODIGO)        = TRIM(P_USUARIO)                                   
            AND TRIM(AP.USU_PERFIL_CODIGO)         = 'CATVFRETE'; 

            COMMIT;

            P_MENSAGEM := 'LIBERADO AVULSO TERCEIRO.';

      --BÔNUS MANIFESTO
      WHEN 13 THEN

         UPDATE TDVADM.T_USU_APLICACAOPERFIL AP
            SET AP.USU_APLICACAOPERFIL_PARAT       = SUBSTR(AP.USU_APLICACAOPERFIL_PARAT,1,12) || 'S' || SUBSTR(AP.USU_APLICACAOPERFIL_PARAT,14,20)
          WHERE TRIM(AP.USU_USUARIO_CODIGO)        = TRIM(P_USUARIO)                                   
            AND TRIM(AP.USU_PERFIL_CODIGO)         = 'CATVFRETE'; 

            COMMIT;

            P_MENSAGEM := 'LIBERADO BÔNUS MANIFESTO.';

      --BÔNUS CTRC
      WHEN 14 THEN

         UPDATE TDVADM.T_USU_APLICACAOPERFIL AP
            SET AP.USU_APLICACAOPERFIL_PARAT       = SUBSTR(AP.USU_APLICACAOPERFIL_PARAT,1,13) || 'S' || SUBSTR(AP.USU_APLICACAOPERFIL_PARAT,15,20)
          WHERE TRIM(AP.USU_USUARIO_CODIGO)        = TRIM(P_USUARIO)                                   
            AND TRIM(AP.USU_PERFIL_CODIGO)         = 'CATVFRETE'; 

            COMMIT;

            P_MENSAGEM := 'LIBERADO BÔNUS CTRC.';

      --OPERAÇÃO COCA-COLA
      WHEN 15 THEN

         UPDATE TDVADM.T_USU_APLICACAOPERFIL AP
            SET AP.USU_APLICACAOPERFIL_PARAT       = SUBSTR(AP.USU_APLICACAOPERFIL_PARAT,1,14) || 'S' || SUBSTR(AP.USU_APLICACAOPERFIL_PARAT,16,20)
          WHERE TRIM(AP.USU_USUARIO_CODIGO)        = TRIM(P_USUARIO)                                   
            AND TRIM(AP.USU_PERFIL_CODIGO)         = 'CATVFRETE'; 

            COMMIT;

            P_MENSAGEM := 'LIBERADO OPERAÇÃO COCA-COLA.';

      --VIAGEM CTRC s/ PLACA
      WHEN 16 THEN

         UPDATE TDVADM.T_USU_APLICACAOPERFIL AP
            SET AP.USU_APLICACAOPERFIL_PARAT       = SUBSTR(AP.USU_APLICACAOPERFIL_PARAT,1,15) || 'S' || SUBSTR(AP.USU_APLICACAOPERFIL_PARAT,17,20)
          WHERE TRIM(AP.USU_USUARIO_CODIGO)        = TRIM(P_USUARIO)                                   
            AND TRIM(AP.USU_PERFIL_CODIGO)         = 'CATVFRETE'; 

            COMMIT;

            P_MENSAGEM := 'LIBERADO VIAGEM CTRC s/ PLACA.';

      --ESTADIA
      WHEN 17 THEN

         UPDATE TDVADM.T_USU_APLICACAOPERFIL AP
            SET AP.USU_APLICACAOPERFIL_PARAT       = SUBSTR(AP.USU_APLICACAOPERFIL_PARAT,1,16) || 'S' || SUBSTR(AP.USU_APLICACAOPERFIL_PARAT,18,20)
          WHERE TRIM(AP.USU_USUARIO_CODIGO)        = TRIM(P_USUARIO)                                   
            AND TRIM(AP.USU_PERFIL_CODIGO)         = 'CATVFRETE'; 

            COMMIT;

            P_MENSAGEM := 'LIBERADO ESTADIA';

      --COLETA
      WHEN 18 THEN

         UPDATE TDVADM.T_USU_APLICACAOPERFIL AP
            SET AP.USU_APLICACAOPERFIL_PARAT       = SUBSTR(AP.USU_APLICACAOPERFIL_PARAT,1,17) || 'S' || SUBSTR(AP.USU_APLICACAOPERFIL_PARAT,19,20)
          WHERE TRIM(AP.USU_USUARIO_CODIGO)        = TRIM(P_USUARIO)                                   
            AND TRIM(AP.USU_PERFIL_CODIGO)         = 'CATVFRETE'; 

            COMMIT;

            P_MENSAGEM := 'LIBERADO COLETA';

      --OPERAÇÕES COM CTRC
      WHEN 19 THEN

         UPDATE TDVADM.T_USU_APLICACAOPERFIL AP
            SET AP.USU_APLICACAOPERFIL_PARAT       = SUBSTR(AP.USU_APLICACAOPERFIL_PARAT,1,18) || 'S' || SUBSTR(AP.USU_APLICACAOPERFIL_PARAT,20,20)
          WHERE TRIM(AP.USU_USUARIO_CODIGO)        = TRIM(P_USUARIO)                                   
            AND TRIM(AP.USU_PERFIL_CODIGO)         = 'CATVFRETE'; 

            COMMIT;

            P_MENSAGEM := 'LIBERADO OPERAÇÕES COM CTRC';

      --ENTREGA DE COLETEIRO
      WHEN 20 THEN

         UPDATE TDVADM.T_USU_APLICACAOPERFIL AP
            SET AP.USU_APLICACAOPERFIL_PARAT       = SUBSTR(AP.USU_APLICACAOPERFIL_PARAT,1,19) || 'S'
          WHERE TRIM(AP.USU_USUARIO_CODIGO)        = TRIM(P_USUARIO)                                   
            AND TRIM(AP.USU_PERFIL_CODIGO)         = 'CATVFRETE'; 

            COMMIT;

            P_MENSAGEM := 'LIBERADO ENTREGA DE COLETEIRO';

      --CASO ELE NÃO TENHA DIGITADO UM NUMERO DE 1 A 20
      ELSE

        P_MENSAGEM := 'Por gentileza informar um numero de 1 a 20.';


    END CASE;

   END IF;

END SP_LIBERA_CATVFRETE;
