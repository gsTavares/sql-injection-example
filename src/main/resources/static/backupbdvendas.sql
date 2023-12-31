PGDMP     9                    {            dbsqlinjection    10.22    10.22 -    7           0    0    ENCODING    ENCODING        SET client_encoding = 'UTF8';
                       false            8           0    0 
   STDSTRINGS 
   STDSTRINGS     (   SET standard_conforming_strings = 'on';
                       false            9           0    0 
   SEARCHPATH 
   SEARCHPATH     8   SELECT pg_catalog.set_config('search_path', '', false);
                       false            :           1262    78857    dbsqlinjection    DATABASE     �   CREATE DATABASE dbsqlinjection WITH TEMPLATE = template0 ENCODING = 'UTF8' LC_COLLATE = 'Portuguese_Brazil.1252' LC_CTYPE = 'Portuguese_Brazil.1252';
    DROP DATABASE dbsqlinjection;
             postgres    false                        2615    2200    public    SCHEMA        CREATE SCHEMA public;
    DROP SCHEMA public;
             postgres    false            ;           0    0    SCHEMA public    COMMENT     6   COMMENT ON SCHEMA public IS 'standard public schema';
                  postgres    false    3                        3079    12924    plpgsql 	   EXTENSION     ?   CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;
    DROP EXTENSION plpgsql;
                  false            <           0    0    EXTENSION plpgsql    COMMENT     @   COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';
                       false    1            �            1255    78858 '   get_quantidade_pedido_vendedor(integer)    FUNCTION     -  CREATE FUNCTION public.get_quantidade_pedido_vendedor(id_vendedor integer) RETURNS integer
    LANGUAGE plpgsql
    AS $$
declare quantidade_pedido integer;
begin
select into quantidade_pedido count(p.num_pedido) from pedido p
where p.codigo_vendedor = id_vendedor;
return quantidade_pedido;
end;
$$;
 J   DROP FUNCTION public.get_quantidade_pedido_vendedor(id_vendedor integer);
       public       postgres    false    1    3            �            1255    78859    get_quantidade_vendedores()    FUNCTION     �   CREATE FUNCTION public.get_quantidade_vendedores() RETURNS integer
    LANGUAGE plpgsql
    AS $$
declare quantidade integer;
begin
select into quantidade count(v.codigo_vendedor) from vendedor v;
return quantidade;
end;
$$;
 2   DROP FUNCTION public.get_quantidade_vendedores();
       public       postgres    false    1    3            �            1255    78860 1   info_cliente(integer, character varying, integer)    FUNCTION     �  CREATE FUNCTION public.info_cliente(id_vendedor integer, estado_param character varying, prazo_entrega_param integer) RETURNS SETOF record
    LANGUAGE plpgsql
    AS $$
declare registro record;
begin
	for registro in(
		select c.codigo_cliente, c.nome_cliente from cliente c
		inner join pedido p on p.codigo_cliente = c.codigo_cliente
		where p.codigo_vendedor = id_vendedor
		and p.prazo_entrega = prazo_entrega_param
		and c.uf = estado_param
	)
	loop
		return next registro;
	end loop;
		return;
end;
$$;
 u   DROP FUNCTION public.info_cliente(id_vendedor integer, estado_param character varying, prazo_entrega_param integer);
       public       postgres    false    1    3            �            1255    78861 /   metricas_vendedor(character varying, character)    FUNCTION     ]  CREATE FUNCTION public.metricas_vendedor(nome_cliente_param character varying, faixa_comissao_param character) RETURNS SETOF record
    LANGUAGE plpgsql
    AS $$
declare registro record;
begin
	for registro in (
		select max(v.salario_fixo), min(v.salario_fixo), avg(v.salario_fixo)
		from vendedor v
		inner join pedido p on p.codigo_vendedor = v.codigo_vendedor
		inner join cliente c on c.codigo_cliente = p.codigo_cliente
		where lower(c.nome_cliente) like lower(concat('%', nome_cliente_param, '%'))
		and v.faixa_comissao = faixa_comissao_param
	)
	loop
		return next registro;
	end loop;
end;
$$;
 n   DROP FUNCTION public.metricas_vendedor(nome_cliente_param character varying, faixa_comissao_param character);
       public       postgres    false    1    3            �            1255    78862    pedidos_vendedor()    FUNCTION     �  CREATE FUNCTION public.pedidos_vendedor() RETURNS SETOF record
    LANGUAGE plpgsql
    AS $$
declare registro record;
begin
	for registro in(
		select p.codigo_vendedor, v.nome_vendedor, count(p.num_pedido) as total_pedido
		from pedido p inner join vendedor v on v.codigo_vendedor = p.codigo_vendedor
		group by p.codigo_vendedor, v.nome_vendedor
	)
	loop
		return next registro;
	end loop;
		return;
end;
$$;
 )   DROP FUNCTION public.pedidos_vendedor();
       public       postgres    false    3    1            �            1255    78863    produtos_pedido(integer)    FUNCTION     �  CREATE FUNCTION public.produtos_pedido(id_pedido integer) RETURNS SETOF record
    LANGUAGE plpgsql
    AS $$
declare registro record;
begin
	for registro in (
		select p.descricao_produto, idp.quantidade, p.val_unit, (p.val_unit * idp.quantidade) as total
		from produto p
		inner join item_do_pedido idp on idp.codigo_produto = p.codigo_produto
		where idp.num_pedido = id_pedido
	)
	loop
		return next registro;
	end loop;
end;
$$;
 9   DROP FUNCTION public.produtos_pedido(id_pedido integer);
       public       postgres    false    3    1            �            1255    78864    resumo_produto()    FUNCTION       CREATE FUNCTION public.resumo_produto() RETURNS SETOF record
    LANGUAGE plpgsql
    AS $$
declare registro record;
begin
	for registro in (
		select p.codigo_produto, p.descricao_produto, p.unidade from produto p
	)
	loop
		return next registro;
	end loop;
end;
$$;
 '   DROP FUNCTION public.resumo_produto();
       public       postgres    false    3    1            �            1255    78865    soma_pedido(integer)    FUNCTION     F  CREATE FUNCTION public.soma_pedido(id_pedido integer) RETURNS numeric
    LANGUAGE plpgsql
    AS $$
declare soma numeric;
begin
	select into soma sum(idp.quantidade * p.val_unit)
	from item_do_pedido idp
	inner join produto p on p.codigo_produto = idp.codigo_produto
	where idp.num_pedido = id_pedido;
	return soma;
end;
$$;
 5   DROP FUNCTION public.soma_pedido(id_pedido integer);
       public       postgres    false    1    3            �            1255    78866 (   vendedores_do_cliente(character varying)    FUNCTION     �  CREATE FUNCTION public.vendedores_do_cliente(nome_cliente_param character varying) RETURNS SETOF record
    LANGUAGE plpgsql
    AS $$
declare registro record;
begin
	for registro in (
		select v.* from vendedor v
		inner join pedido p on p.codigo_vendedor = v.codigo_vendedor
		inner join cliente c on c.codigo_cliente = p.codigo_cliente
		where lower(c.nome_cliente) like lower(concat('%', nome_cliente_param, '%'))
		group by v.codigo_vendedor
	)
	loop
		return next registro;
	end loop;
		return;
end;
$$;
 R   DROP FUNCTION public.vendedores_do_cliente(nome_cliente_param character varying);
       public       postgres    false    3    1            �            1259    78867    cliente    TABLE     O  CREATE TABLE public.cliente (
    codigo_cliente integer NOT NULL,
    nome_cliente character varying(40),
    endereco character varying(50),
    cidade character varying(30),
    cep character(10),
    uf character(2),
    cgc character(16),
    ie character(20),
    senha character varying(255) DEFAULT '123'::character varying
);
    DROP TABLE public.cliente;
       public         postgres    false    3            �            1259    78870 
   cliente_sp    VIEW     �   CREATE VIEW public.cliente_sp AS
 SELECT c.codigo_cliente,
    c.nome_cliente
   FROM public.cliente c
  WHERE ((c.uf = 'SP'::bpchar) OR (c.uf = 'RJ'::bpchar) OR (c.uf = 'MS'::bpchar));
    DROP VIEW public.cliente_sp;
       public       postgres    false    196    196    196    3            �            1259    78874    item_do_pedido    TABLE     �   CREATE TABLE public.item_do_pedido (
    num_pedido integer NOT NULL,
    codigo_produto integer NOT NULL,
    quantidade numeric(10,2)
);
 "   DROP TABLE public.item_do_pedido;
       public         postgres    false    3            �            1259    78877    produto    TABLE     �   CREATE TABLE public.produto (
    codigo_produto integer NOT NULL,
    unidade character(3),
    descricao_produto character varying(30),
    val_unit numeric(10,2)
);
    DROP TABLE public.produto;
       public         postgres    false    3            �            1259    78880    info_pedido    VIEW     *  CREATE VIEW public.info_pedido AS
 SELECT idp.num_pedido,
    idp.codigo_produto,
    p.descricao_produto,
    idp.quantidade,
    p.val_unit,
    (idp.quantidade * p.val_unit) AS subtotal
   FROM (public.item_do_pedido idp
     JOIN public.produto p ON ((idp.codigo_produto = p.codigo_produto)));
    DROP VIEW public.info_pedido;
       public       postgres    false    199    199    199    198    198    198    3            �            1259    78884    pedido    TABLE     �   CREATE TABLE public.pedido (
    num_pedido integer NOT NULL,
    prazo_entrega smallint NOT NULL,
    codigo_cliente integer NOT NULL,
    codigo_vendedor integer NOT NULL
);
    DROP TABLE public.pedido;
       public         postgres    false    3            �            1259    78887    vendedor    TABLE     �   CREATE TABLE public.vendedor (
    codigo_vendedor integer NOT NULL,
    nome_vendedor character varying(40),
    salario_fixo numeric(10,2),
    faixa_comissao character(1)
);
    DROP TABLE public.vendedor;
       public         postgres    false    3            �            1259    78890    pedido_carlos    VIEW     �   CREATE VIEW public.pedido_carlos AS
 SELECT p.num_pedido,
    p.codigo_cliente,
    p.prazo_entrega
   FROM (public.pedido p
     JOIN public.vendedor v ON ((v.codigo_vendedor = p.codigo_vendedor)))
  WHERE ((v.nome_vendedor)::text = 'Carlos'::text);
     DROP VIEW public.pedido_carlos;
       public       postgres    false    201    201    201    201    202    202    3            �            1259    78894    total_vendas_vendedor    VIEW     �   CREATE VIEW public.total_vendas_vendedor AS
SELECT
    NULL::integer AS codigo_vendedor,
    NULL::character varying(40) AS nome_vendedor,
    NULL::numeric(10,2) AS salario_fixo,
    NULL::numeric AS total_vendas;
 (   DROP VIEW public.total_vendas_vendedor;
       public       postgres    false    3            �            1259    78898    salario_total_vendedor    VIEW     �   CREATE VIEW public.salario_total_vendedor AS
 SELECT tvv.nome_vendedor,
    tvv.salario_fixo,
    tvv.total_vendas,
    (tvv.salario_fixo + (tvv.total_vendas * 0.05)) AS salario_total
   FROM public.total_vendas_vendedor tvv;
 )   DROP VIEW public.salario_total_vendedor;
       public       postgres    false    204    204    204    3            �            1259    78902    soma_total_pedido    VIEW     �   CREATE VIEW public.soma_total_pedido AS
 SELECT ip.num_pedido,
    sum(ip.subtotal) AS total
   FROM public.info_pedido ip
  GROUP BY ip.num_pedido;
 $   DROP VIEW public.soma_total_pedido;
       public       postgres    false    200    200    3            �            1259    78906    total_pedido_vendedor    VIEW     �   CREATE VIEW public.total_pedido_vendedor AS
SELECT
    NULL::integer AS num_pedido,
    NULL::integer AS codigo_vendedor,
    NULL::character varying(40) AS nome_vendedor,
    NULL::numeric(10,2) AS salario_fixo,
    NULL::numeric AS total;
 (   DROP VIEW public.total_pedido_vendedor;
       public       postgres    false    3            0          0    78867    cliente 
   TABLE DATA               j   COPY public.cliente (codigo_cliente, nome_cliente, endereco, cidade, cep, uf, cgc, ie, senha) FROM stdin;
    public       postgres    false    196   .F       1          0    78874    item_do_pedido 
   TABLE DATA               P   COPY public.item_do_pedido (num_pedido, codigo_produto, quantidade) FROM stdin;
    public       postgres    false    198   I       3          0    78884    pedido 
   TABLE DATA               \   COPY public.pedido (num_pedido, prazo_entrega, codigo_cliente, codigo_vendedor) FROM stdin;
    public       postgres    false    201   �I       2          0    78877    produto 
   TABLE DATA               W   COPY public.produto (codigo_produto, unidade, descricao_produto, val_unit) FROM stdin;
    public       postgres    false    199   @J       4          0    78887    vendedor 
   TABLE DATA               `   COPY public.vendedor (codigo_vendedor, nome_vendedor, salario_fixo, faixa_comissao) FROM stdin;
    public       postgres    false    202   �J       �
           2606    78911    cliente pk_codigo_cliente 
   CONSTRAINT     c   ALTER TABLE ONLY public.cliente
    ADD CONSTRAINT pk_codigo_cliente PRIMARY KEY (codigo_cliente);
 C   ALTER TABLE ONLY public.cliente DROP CONSTRAINT pk_codigo_cliente;
       public         postgres    false    196            �
           2606    78913    vendedor pk_codigo_vendedor 
   CONSTRAINT     f   ALTER TABLE ONLY public.vendedor
    ADD CONSTRAINT pk_codigo_vendedor PRIMARY KEY (codigo_vendedor);
 E   ALTER TABLE ONLY public.vendedor DROP CONSTRAINT pk_codigo_vendedor;
       public         postgres    false    202            �
           2606    78915    item_do_pedido pk_item_pedido 
   CONSTRAINT     s   ALTER TABLE ONLY public.item_do_pedido
    ADD CONSTRAINT pk_item_pedido PRIMARY KEY (num_pedido, codigo_produto);
 G   ALTER TABLE ONLY public.item_do_pedido DROP CONSTRAINT pk_item_pedido;
       public         postgres    false    198    198            �
           2606    78917    pedido pk_num_pedido 
   CONSTRAINT     Z   ALTER TABLE ONLY public.pedido
    ADD CONSTRAINT pk_num_pedido PRIMARY KEY (num_pedido);
 >   ALTER TABLE ONLY public.pedido DROP CONSTRAINT pk_num_pedido;
       public         postgres    false    201            �
           2606    78919    produto pk_produto 
   CONSTRAINT     \   ALTER TABLE ONLY public.produto
    ADD CONSTRAINT pk_produto PRIMARY KEY (codigo_produto);
 <   ALTER TABLE ONLY public.produto DROP CONSTRAINT pk_produto;
       public         postgres    false    199            ,           2618    78897    total_vendas_vendedor _RETURN    RULE       CREATE OR REPLACE VIEW public.total_vendas_vendedor AS
 SELECT tpv.codigo_vendedor,
    tpv.nome_vendedor,
    tpv.salario_fixo,
    sum(tpv.total) AS total_vendas
   FROM public.total_pedido_vendedor tpv
  GROUP BY tpv.codigo_vendedor, tpv.nome_vendedor, tpv.salario_fixo;
 �   CREATE OR REPLACE VIEW public.total_vendas_vendedor AS
SELECT
    NULL::integer AS codigo_vendedor,
    NULL::character varying(40) AS nome_vendedor,
    NULL::numeric(10,2) AS salario_fixo,
    NULL::numeric AS total_vendas;
       public       postgres    false    207    207    207    207    204            /           2618    78909    total_pedido_vendedor _RETURN    RULE     �  CREATE OR REPLACE VIEW public.total_pedido_vendedor AS
 SELECT idp.num_pedido,
    v.codigo_vendedor,
    v.nome_vendedor,
    v.salario_fixo,
    sum((idp.quantidade * p.val_unit)) AS total
   FROM (((public.item_do_pedido idp
     JOIN public.produto p ON ((idp.codigo_produto = p.codigo_produto)))
     JOIN public.pedido pe ON ((pe.num_pedido = idp.num_pedido)))
     JOIN public.vendedor v ON ((v.codigo_vendedor = pe.codigo_vendedor)))
  GROUP BY idp.num_pedido, v.codigo_vendedor, v.nome_vendedor;
 �   CREATE OR REPLACE VIEW public.total_pedido_vendedor AS
SELECT
    NULL::integer AS num_pedido,
    NULL::integer AS codigo_vendedor,
    NULL::character varying(40) AS nome_vendedor,
    NULL::numeric(10,2) AS salario_fixo,
    NULL::numeric AS total;
       public       postgres    false    198    202    202    202    201    201    199    199    198    198    2731    207            �
           2606    78921     item_do_pedido fk_codigo_produto    FK CONSTRAINT     �   ALTER TABLE ONLY public.item_do_pedido
    ADD CONSTRAINT fk_codigo_produto FOREIGN KEY (codigo_produto) REFERENCES public.produto(codigo_produto);
 J   ALTER TABLE ONLY public.item_do_pedido DROP CONSTRAINT fk_codigo_produto;
       public       postgres    false    198    2727    199            �
           2606    78926    pedido fk_codigo_vendedor    FK CONSTRAINT     �   ALTER TABLE ONLY public.pedido
    ADD CONSTRAINT fk_codigo_vendedor FOREIGN KEY (codigo_vendedor) REFERENCES public.vendedor(codigo_vendedor);
 C   ALTER TABLE ONLY public.pedido DROP CONSTRAINT fk_codigo_vendedor;
       public       postgres    false    2731    201    202            �
           2606    78931    item_do_pedido fk_num_pedido    FK CONSTRAINT     �   ALTER TABLE ONLY public.item_do_pedido
    ADD CONSTRAINT fk_num_pedido FOREIGN KEY (num_pedido) REFERENCES public.pedido(num_pedido);
 F   ALTER TABLE ONLY public.item_do_pedido DROP CONSTRAINT fk_num_pedido;
       public       postgres    false    2729    198    201            �
           2606    78936    pedido fk_num_pedio    FK CONSTRAINT     �   ALTER TABLE ONLY public.pedido
    ADD CONSTRAINT fk_num_pedio FOREIGN KEY (codigo_cliente) REFERENCES public.cliente(codigo_cliente);
 =   ALTER TABLE ONLY public.pedido DROP CONSTRAINT fk_num_pedio;
       public       postgres    false    201    2723    196            0   �  x�u��r�0���)�`�ْ�@�6�Ph�b#����X�lX�m:]e�Uv���z$J�L��{�wΕь\���C���@�lG�������U��Ӆ�מ�i%�����K�E�Yi��R������p!27>ܗd�wt�*��K2݇��6�Hƴ���K�U�QIe�H�׷IFAf����%���m��(љ��%���tݬ��>T�}ӕ�%m�y��#y.�D��%�l�F22w��?�%.���j�T��m�	���HF�#)/ �iU�ÂT������i��� D�&#+W�և��h2&�\@_�����y�
�~��/��`���3�sTh��M�:YV���7�)���f�Tky#a����h�V\�������C� ܌�kL"/N�$L��1DZ�"b�a�1�>��W��.�d�m�S��D.F�Ay(�Y+.p7qz:�~D'e�܅�2G�X
��5������EC��BA�"�<r�C��+�o]s�����l��H�����?WQ�8��u�T��y��Բq�O%�h��O�n�@>G��kOܹĆ�j8�c�܈��$��ʍk�
b��^߇+K2�iS��X�*H%�k2N�+�a߆��X�/$G*�m�H>��.�!��)��$���O56_�_j8�����c�>_H�F<�L�:5n_����j��y>�g�1>Ds�@�U]���oٜ:9      1   �   x�MPK![�a&"0�]�����H��E��Pą�p>stB�$�VP�U�La7V�&HP�@Bd�ƞ�������w�1� kR��l��ώNA'Q���"x��]��rM6�Ÿ�f�#T���G�v�۱.�}p�������\@���{���>�      3   }   x�UNA1:��tDM����Q��l��A �0�SR��"�b`��?*!��3g�9���é�RM�i6U*�V�;�:;�K�{��oʠ��[8<O��1V:S��u�-�����D�tK(�      2   �   x�=�M
�0����)z�0I���څ[�Wn��Ji��3y���C���q�o28M�{$ ��h5l�3m�Sϯ(<� e����F�1P�����-�%/ ����Q�:���
���N�0�	�J\�%����ef�X�C����?8�3�"����#,Z      4   �   x�=�1�0 g�1��$M2B%$~������ELl� �T)���6c�sY��#v�0("�!�SY�M��A�x�Y��o�G��T �=w�p�t���r&-}��R�𿳷-ք����m��"\�:��Mq�ͽvJ�/��.K     