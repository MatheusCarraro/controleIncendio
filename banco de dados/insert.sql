insert into servico_seguranca (id, usuario, senha) values (1 ,'bombeiro', '123');

insert into cliente_final (id, nome, servico_seguranca_id, tipo_pessoa) values (1, 'Casa da Raimunda', 1, 'f');
insert into cliente_final (id, nome, servico_seguranca_id, tipo_pessoa) values (2, 'Empresa do Getúlio', 1, 'j');

insert into pessoa_fisica (cliente_id, cpf) values (1, '12345678900');
insert into pessoa_juridica (cliente_id, cnpj) values (2, '123456789123456');

insert into telefone_associado (id, numero, cliente_id) values (1, '47997451245', 1);
insert into telefone_associado (id, numero, cliente_id) values (2, '47994512245', 2);

insert into endereco (id, cep, logradouro, numero, referencia, bairro, municipio, uf)
values (1, '88301016', 'Rua Eurico Krobel', 345, 'perto do mercado', 'Centro', 'Itajaí', 'SC');
insert into endereco (id, cep, logradouro, numero, referencia, bairro, municipio, uf)
values (2, '88301220', 'Rua Aderbal Ramos da Silva', 768, 'perto da farmácia', 'Centro', 'Itajaí', 'SC');

insert into instalacao (id, data_instalacao, cliente_final_id, endereco_id, dispositivo, gas_threshold, humi_threshold, temp_threshold) 
values (1, '2019-05-25', 1, 1, 1, 3000, 80, 25);
insert into instalacao (id, data_instalacao, cliente_final_id, endereco_id, dispositivo, gas_threshold, humi_threshold, temp_threshold) 
values (2, '2018-12-02', 2, 2, 2, 3000, 80, 25);

insert into ocorrencia (id, data_ocorrencia, temperatura, densidade_fumaca, instalacao_id, estado)
values (1, '2019-01-10', 80.00, 135.00, 2, 1);