package com.sqlinjection.dbsecurity.repository;

import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.sqlinjection.dbsecurity.domain.Cliente;

import jakarta.persistence.EntityManager;

@Repository
public class ClienteCustomRepository {

    @Autowired
    private EntityManager em;

    public Optional<Cliente> findByNomeClienteAndSenha(String nomeCliente, String senha) {
        String sql = String.format("SELECT * FROM cliente WHERE nome_cliente = %s AND senha = %s", nomeCliente, senha);
        Optional<Cliente> busca = Optional.ofNullable(null);
        try {
            busca = Optional.ofNullable((Cliente) this.em.createNativeQuery(sql, Cliente.class).getSingleResult());
        } catch (Exception e) {
            System.out.println("Erro ao realizar login\nErro: " + e.getMessage());
        } finally {
            this.em.close();
        }
        return busca;
    }

}
