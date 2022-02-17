select e.arm_embalagem_numero EMBALAGEM,
       e.arm_armazem_codigo ARMAZEM_EMB,
       n.arm_armazem_codigo ARMAZEM_ORIGEM,
       d.arm_armazem_codigo_transf,
       d.arm_carregamentodet_dcheckin,
       d.usu_usuario_codigocheckin
  from tdvadm.t_con_vfreteconhec v,
       tdvadm.t_arm_nota n,
       tdvadm.t_arm_embalagem e,
       tdvadm.t_arm_carregamentodet d
   where 0=0
     and v.con_conhecimento_codigo = n.con_conhecimento_codigo
     and v.con_valefrete_serie     = n.con_conhecimento_serie
     and v.glb_rota_codigo         = n.glb_rota_codigo
     and n.arm_embalagem_numero    = e.arm_embalagem_numero
     and e.arm_embalagem_numero    = d.arm_embalagem_numero
     and e.arm_carregamento_codigo = d.arm_carregamento_codigo
     and e.arm_embalagem_numero    = '1599511'
