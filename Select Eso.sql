SELECT *
       FROM TDVADM.T_CAR_ESOCIAL E
       WHERE 0=0                 
         AND E.CAR_PROPRIETARIO_CGCCPFCODIGO = '06171319619' 
         AND E.CAR_PROPRIETARIO_RAZAOSOCIAL LIKE '%TANLEN%'
       FOR UPDATE
         
    SELECT *
           FROM TDVADM.T_CON_FRETEOPER F
           WHERE 0=0
             AND F.CON_FRETEOPER_ID = '119735'
             AND F.CON_FRETEOPER_ROTA  = '045' 
             AND F.CFE_STATUSFRETEOPER_STATUS = 'IV'
             AND F.CFE_OPERACOES_COD   = '085'
           FOR UPDATE