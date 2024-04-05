with tb_join as (

select t2.*
, t3.idVendedor

    from pedido as t1

    left join pagamento_pedido as t2
    on t1.idPedido = t2.idPedido

    left join item_pedido t3
    on t1.idPedido = t3.idPedido

        where t1.dtPedido < '2018-01-01'
        and t1.dtPedido >= date('2018-01-01', '-6 month')
        and t3.idVendedor is not null
), 

tb_group as (

select idVendedor
, descTipoPagamento
, count(DISTINCT idPedido) as qtdePedidoMeioPagamento
, sum(vlPagamento) as vlPedidoMeioPagamento
    
    from tb_join

        group by idVendedor
        , descTipoPagamento

            order by idVendedor
            , descTipoPagamento
)

select idVendedor
, sum(case when descTipoPagamento = 'credit_card' then qtdePedidoMeioPagamento 
    else 0 
end) as qtde_credit_card_pedido
, sum(case when descTipoPagamento = 'boleto' then qtdePedidoMeioPagamento 
    else 0 
end) as qtde_boleto_pedido
, sum(case when descTipoPagamento = 'debit_card' then qtdePedidoMeioPagamento 
    else 0 
end) as qtde_debit_card_pedido
, sum(case when descTipoPagamento = 'voucher' then qtdePedidoMeioPagamento 
    else 0 
end) as qtde_voucher_pedido

, sum(case when descTipoPagamento = 'credit_card' then vlPedidoMeioPagamento 
    else 0 
end) as vl_credit_card_pedido
, sum(case when descTipoPagamento = 'boleto' then vlPedidoMeioPagamento 
    else 0 
end) as vl_boleto_pedido
, sum(case when descTipoPagamento = 'debit_card' then vlPedidoMeioPagamento 
    else 0 
end) as vl_debit_card_pedido
, sum(case when descTipoPagamento = 'voucher' then vlPedidoMeioPagamento 
    else 0 
end) as vl_voucher_pedido

, sum(case when descTipoPagamento = 'credit_card' then qtdePedidoMeioPagamento 
    else 0 
end) / cast(sum(qtdePedidoMeioPagamento) as float) as pct_qtd_credit_card_pedido
, sum(case when descTipoPagamento = 'boleto' then qtdePedidoMeioPagamento 
    else 0 
end) / cast(sum(qtdePedidoMeioPagamento) as float) as pct_qtd_boleto_pedido
, sum(case when descTipoPagamento = 'debit_card' then qtdePedidoMeioPagamento 
    else 0 
end) / cast(sum(qtdePedidoMeioPagamento) as float) as pct_qtd_debit_card_pedido
, sum(case when descTipoPagamento = 'voucher' then qtdePedidoMeioPagamento 
    else 0 
end) / cast(sum(qtdePedidoMeioPagamento) as float) as pct_qtd_voucher_pedido

, sum(case when descTipoPagamento = 'credit_card' then vlPedidoMeioPagamento 
    else 0 
end) / sum(vlPedidoMeioPagamento) as pct_valor_credit_card_pedido
, sum(case when descTipoPagamento = 'boleto' then vlPedidoMeioPagamento 
    else 0 
end) / sum(vlPedidoMeioPagamento) as pct_valor_boleto_pedido
, sum(case when descTipoPagamento = 'debit_card' then vlPedidoMeioPagamento 
    else 0 
end) / sum(vlPedidoMeioPagamento) as pct_valor_debit_card_pedido
, sum(case when descTipoPagamento = 'voucher' then vlPedidoMeioPagamento 
    else 0 
end) / sum(vlPedidoMeioPagamento) as pct_valor_voucher_pedido
    from tb_group

        group by 1
