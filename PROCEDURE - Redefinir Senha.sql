CREATE OR REPLACE PROCEDURE SP_REDEFINIR_SENHA_EXTRANET(p_LOGIN VARCHAR2,
                                                        p_MENSAGEM IN OUT VARCHAR2)
IS   
   --VARIAVEL AUXILIAR 
   --ARMAZENA O VALOR EXIBIDO NO COUNT                                             
   V_LOGIN_EXISTE NUMBER;
   
   
   V_SENHA NUMBER;
   
BEGIN
   
   --VERIFICA SE O USU�RIO EXISTE, 
   SELECT COUNT(*)
   INTO V_LOGIN_EXISTE
   FROM WTDVCORE.T_PES_USUARIO U1
   WHERE TRIM(U1.PES_USUARIO_LOGIN) = TRIM(p_LOGIN);
   
     
   --VERIFICA SE A SENHA DO USU�RIO DIGITADO, J� � "amarelo1"
   SELECT COUNT(*)
   INTO V_SENHA
   FROM WTDVCORE.T_PES_USUARIO U2
   WHERE TRIM(U2.PES_USUARIO_LOGIN) = TRIM(p_LOGIN)
   AND U2.PES_USUARIO_SENHA <> '55de58ef9a8b1d07bff4b02aa702c3fe06ff27f2731ba46409c2dcf183489734';
   
      
   --SE O COUNT ACIMA DER ACIMA DE 0
   --EXECUTA O UPDATE
   IF (V_LOGIN_EXISTE > 0) AND (V_SENHA > 0) THEN
       
     UPDATE WTDVCORE.T_PES_USUARIO U3
     SET U3.PES_USUARIO_SENHA = '55de58ef9a8b1d07bff4b02aa702c3fe06ff27f2731ba46409c2dcf183489734'
     WHERE TRIM(U3.PES_USUARIO_LOGIN) = TRIM(p_LOGIN);
     p_MENSAGEM := 'SENHA DO USU�RIO REDEFINIDA.';
     commit;
   
   --VERIFICA SE O USU�RIO EXISTE
   ELSIF (V_LOGIN_EXISTE = 0) THEN
     
     p_MENSAGEM := 'O USU�RIO DIGITADO N�O EXISTE!';
   
   --VERIFICA SE A SENHA � AMARELO1  
   ELSE --(V_SENHA < 0) THEN
     
     p_MENSAGEM := 'A SENHA DESTE USU�RIO JA � amarelo1 ';
     
   END IF;
   
     
END SP_REDEFINIR_SENHA_EXTRANET;





--EXECUTE
exec SP_REDEFINIR_SENHA_EXTRANET;

/*
SELECT *
FROM WTDVCORE.T_PES_USUARIO r
where r.pes_usuario_login = 'tsilva' for update
*/
