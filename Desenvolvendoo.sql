--PROC PARA APARECER CARREGAMENTO/EMBALAGEM NO MENU
--CTRC SE TIVER FECHADO CARREGAMENTO
--FIFO SE EMBALAGEM ESTIVER SEM CARREGAMENTO
--DANIEU

CREATE OR REPLACE PROCEDURE SP_EMBALAGEM_SUMIU (P_EMBALAGEM    IN TDVADM.T_ARM_EMBALAGEM.ARM_EMBALAGEM_NUMERO%TYPE,
                                                --P_CARREGAMENTO IN TDVADM.T_ARM_EMBALAGEM.ARM_CARREGAMENTO_CODIGO%TYPE,
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
     FROM TDVADM.T_ARM_EMBALAGEM E1
    WHERE TRIM(E1.ARM_EMBALAGEM_NUMERO) = TRIM(P_EMBALAGEM);
   
  

   
                   
   --verificando se embalagem tem carregamento
   --e se o mesmo existe
   
   IF(V_COUNT_EMBALAGEM > 0) THEN
     
     SELECT E2.ARM_CARREGAMENTO_CODIGO
       INTO V_CARREGAMENTO
       FROM TDVADM.T_ARM_EMBALAGEM E2
      WHERE TRIM(E2.ARM_EMBALAGEM_NUMERO) = TRIM(P_EMBALAGEM);
  
     
     --se embalagem estiver sem carregamento, logo deverá aparecer no fifo
     --para ser vinculado a um.
          
     IF (V_CARREGAMENTO IS NULL) THEN
       
        --verificando se embalagem tem contrato,
        --se não tem, não aparece no fifo.
                                
        SELECT N.SLF_CONTRATO_CODIGO
          INTO V_EXISTE_CONTRATO
          FROM TDVADM.T_ARM_NOTA N
         WHERE TRIM(N.ARM_EMBALAGEM_NUMERO) = TRIM(N.ARM_EMBALAGEM_NUMERO);
        
        IF(V_EXISTE_CONTRATO IS NULL) THEN
        
          P_MENSAGEM := 'Embalagem encontra-se sem contrato!';
        
        ELSE
          
          --atualizo a data inclusão e fechado para uma data atual.
          
          UPDATE TDVADM.T_ARM_EMBALAGEM E3
             SET E3.ARM_EMBALAGEM_DTINCLUSAO   = SYSDATE
           WHERE TRIM(E3.ARM_EMBALAGEM_NUMERO) = TRIM(P_EMBALAGEM)
          COMMIT;
              
          UPDATE TDVADM.T_ARM_EMBALAGEM E4
             SET E4.ARM_EMBALAGEM_DTFECHADO    = SYSDATE
           WHERE TRIM(E4.ARM_EMBALAGEM_NUMERO) = TRIM(P_EMBALAGEM)
           COMMIT;
        
          P_MENSAGEM := 'Embalagem no FIFO, verificar!';  
        
        END IF;
        


     ELSE --tendo carregamento verifico os proximos passos...
       
       --verificando se carregamento tem data de fechamento.
       SELECT COUNT(*)
         INTO V_FECHADO
         FROM TDVADM.T_ARM_CARREGAMENTO C
        WHERE TRIM(C.ARM_CARREGAMENTO_CODIGO) = TRIM(V_CARREGAMENTO)
          AND C.ARM_CARREGAMENTO_DTFECHAMENTO IS NOT NULL; --preenchido após fechar
          
          IF(V_FECHADO > 0) THEN
            
            --tendo dt de fechamento, deve aparecer no ctrc
            
            --atualizo embalagem e a data de fechamento
            --do carregamento para data atual.
            
            UPDATE TDVADM.T_ARM_EMBALAGEM E5
               SET E5.ARM_EMBALAGEM_DTINCLUSAO   = SYSDATE
             WHERE TRIM(E5.ARM_EMBALAGEM_NUMERO) = TRIM(P_EMBALAGEM)
             COMMIT;
              
            UPDATE TDVADM.T_ARM_EMBALAGEM E6
               SET E6.ARM_EMBALAGEM_DTFECHADO    = SYSDATE
             WHERE TRIM(E6.ARM_EMBALAGEM_NUMERO) = TRIM(P_EMBALAGEM)
             COMMIT;
             
            UPDATE TDVADM.T_ARM_CARREGAMENTO C1
               SET C1.ARM_CARREGAMENTO_DTFECHAMENTO = SYSDATE
             WHERE TRIM(C1.ARM_CARREGAMENTO_CODIGO) = TRIM(V_CARREGAMENTO)
             COMMIT;
             
             
            --buscando veiculo disp de um outro carregamento
            --obs: do mesmo armazém 
            --veiculo disp sem placa
            
            SELECT D.CAR_VEICULO_PLACA
              INTO V_VEICULODISP
              FROM TDVADM.T_FCF_VEICULODISP  D,
                   TDVADM.T_ARM_CARREGAMENTO C
             WHERE C.ARM_CARREGAMENTO_CODIGO = D.ARM_CARREGAMENTO_CODIGO
               AND C.FCF_VEICULODISP_CODIGO  = D.FCF_VEICULODISP_CODIGO
               AND C.ARM_CARREGAMENTO_CODIGO = V_CARREGAMENTO;
               
               
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
   
   

   
   
      
   --SE O COUNT ACIMA DER ACIMA DE 0
   --EXECUTA O UPDATE
   IF (V_LOGIN_EXISTE > 0) AND (V_SENHA > 0) THEN
       
     UPDATE WTDVCORE.T_PES_USUARIO U3
     SET U3.PES_USUARIO_SENHA = '55de58ef9a8b1d07bff4b02aa702c3fe06ff27f2731ba46409c2dcf183489734'
     WHERE U3.PES_USUARIO_LOGIN = p_LOGIN;
     p_MENSAGEM := 'SENHA DO USUÁRIO REDEFINIDA.';
     commit;
   
   --VERIFICA SE O USUÁRIO EXISTE
   ELSIF (V_LOGIN_EXISTE = 0) THEN
     
     p_MENSAGEM := 'O USUÁRIO DIGITADO NÃO EXISTE!';
   
   --VERIFICA SE A SENHA É AMARELO1  
   ELSE --(V_SENHA < 0) THEN
     
     p_MENSAGEM := 'A SENHA DESTE USUÁRIO JA É amarelo1 ';
     
   END IF;
   
     
END SP_REDEFINIR_SENHA_EXTRANET;
