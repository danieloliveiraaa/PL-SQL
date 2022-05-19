--PROC PARA APARECER CARREGAMENTO/EMBALAGEM NO MENU
--CTRC SE TIVER FECHADO CARREGAMENTO
--FIFO SE EMBALAGEM ESTIVER SEM CARREGAMENTO
--DANIEU

CREATE OR REPLACE PROCEDURE SP_EMBALAGEM_SUMIU (P_EMBALAGEM    IN TB_EMBALAGEM.EMBALAGEM_NUMERO%TYPE,
                                                --P_CARREGAMENTO IN TB_EMBALAGEM.CARREGAMENTO_CODIGO%TYPE,
                                                P_MENSAGEM     OUT VARCHAR2)
IS   
                                           
   V_COUNT_EMBALAGEM     NUMBER;
   V_CARREGAMENTO        CHAR;
   V_FECHADO             NUMBER;
   V_EXISTE_CONTRATO     NUMBER;
   V_VEICULODISP_PLACA   CHAR;
   
BEGIN
   
   --embalagem existe??
   SELECT COUNT(*)
     INTO V_COUNT_EMBALAGEM
     FROM TB_EMBALAGEM E1
    WHERE TRIM(E1.EMBALAGEM_NUMERO) = TRIM(P_EMBALAGEM);
   
  

   
                   
   --verificando se embalagem tem carregamento
   --e se o mesmo existe
   
   IF (V_COUNT_EMBALAGEM > 0) THEN
     
     SELECT E2.CARREGAMENTO_CODIGO
       INTO V_CARREGAMENTO
       FROM TB_EMBALAGEM E2
      WHERE TRIM(E2.EMBALAGEM_NUMERO) = TRIM(P_EMBALAGEM);
  
     
     --se embalagem estiver sem carregamento, logo deverá aparecer no fifo
     --para ser vinculado a um.
          
     IF (V_CARREGAMENTO IS NULL) THEN
       
        --verificando se embalagem tem contrato,
        --se não tem, não aparece no fifo.
                                
        SELECT N.SLF_CONTRATO_CODIGO
          INTO V_EXISTE_CONTRATO
          FROM TB_NOTA N
         WHERE TRIM(N.EMBALAGEM_NUMERO) = TRIM(N.EMBALAGEM_NUMERO);
        
        IF(V_EXISTE_CONTRATO IS NULL) THEN
        
          P_MENSAGEM := 'Embalagem encontra-se sem contrato!';
        
        ELSE
          
          --atualizo a data inclusão e fechado para uma data atual.
          
          UPDATE TDVADM.T_ARM_EMBALAGEM E3
             SET E3.EMBALAGEM_DTINCLUSAO   = SYSDATE
           WHERE TRIM(E3.EMBALAGEM_NUMERO) = TRIM(P_EMBALAGEM)
          COMMIT;
              
          UPDATE TB_EMBALAGEM E4
             SET E4.EMBALAGEM_DTFECHADO    = SYSDATE
           WHERE TRIM(E4.EMBALAGEM_NUMERO) = TRIM(P_EMBALAGEM)
           COMMIT;
        
          P_MENSAGEM := 'Embalagem no FIFO, verificar!';  
        
        END IF;
        


     ELSE --tendo carregamento verifico os proximos passos...
       
       --verificando se carregamento tem data de fechamento.
       SELECT COUNT(*)
         INTO V_FECHADO
         FROM TB_CARREGAMENTO C
        WHERE TRIM(C.CARREGAMENTO_CODIGO) = TRIM(V_CARREGAMENTO)
          AND C.CARREGAMENTO_DTFECHAMENTO IS NOT NULL; --preenchido após fechar
          
          IF(V_FECHADO > 0) THEN
            
            --tendo dt de fechamento, deve aparecer no ctrc
            
            --atualizo embalagem e a data de fechamento
            --do carregamento para data atual.
            
            UPDATE TDVADM.TB_EMBALAGEM E5
               SET E5.EMBALAGEM_DTINCLUSAO   = SYSDATE
             WHERE TRIM(E5.EMBALAGEM_NUMERO) = TRIM(P_EMBALAGEM)
             COMMIT;
              
            UPDATE TB_EMBALAGEM E6
               SET E6.EMBALAGEM_DTFECHADO    = SYSDATE
             WHERE TRIM(E6.EMBALAGEM_NUMERO) = TRIM(P_EMBALAGEM)
             COMMIT;
             
            UPDATE TB_CARREGAMENTO C1
               SET C1.CARREGAMENTO_DTFECHAMENTO = SYSDATE
             WHERE TRIM(C1.CARREGAMENTO_CODIGO) = TRIM(V_CARREGAMENTO)
             COMMIT;
             
             
            --buscando veiculo disp de um outro carregamento
            --obs: do mesmo armazém 
            --veiculo disp sem placa
            
            SELECT D.CAR_VEICULO_PLACA
              INTO V_VEICULODISP
              FROM TB VEICULODISP  D,
                   TB_CARREGAMENTO C
             WHERE C.CARREGAMENTO_CODIGO = D.CARREGAMENTO_CODIGO
               AND C.VEICULODISP_CODIGO  = D.VEICULODISP_CODIGO
               AND C.CARREGAMENTO_CODIGO = V_CARREGAMENTO;
               
               
               IF() THEN
               ELSE
               END IF;
               
               
               
               
             
              
             
            
             
             
          ELSE
            
          END IF;
            
       
       
     END IF;
        
        
   --VERIFICO SE, O CARREGAMENTO VINCULADO A EMBALAGEM,
   --POSSUI DATA DE FECHAMENTO
   
  
   ELSE
     
     P_MENSAGEM := 'Embalagem inexistente';
     
   END IF;
   
   

   
   
     
END;
