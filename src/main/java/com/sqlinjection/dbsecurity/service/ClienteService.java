package com.sqlinjection.dbsecurity.service;

import java.util.HashMap;
import java.util.Map;
import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;

import com.sqlinjection.dbsecurity.domain.Cliente;
import com.sqlinjection.dbsecurity.repository.ClienteCustomRepository;
import com.sqlinjection.dbsecurity.repository.ClienteRepository;

@Service
public class ClienteService {

    @Autowired
    private ClienteRepository clienteRepository;

    @Autowired
    private ClienteCustomRepository clienteCustomRepository;

    public ResponseEntity<Map<String, String>> login(String nomeCliente, String senha) {
        Map<String, String> resposta = new HashMap<>();
        Optional<Cliente> busca = this.clienteRepository.findByNomeClienteAndSenha(nomeCliente, senha);
        resposta.put("mensagem", busca.isPresent() ? "Login realizado com sucesso!" : "Usuário ou senha incorretos. Tente novamente!");
        return ResponseEntity.status(busca.isPresent() ? HttpStatus.OK : HttpStatus.NOT_FOUND).body(resposta);
    }

    public ResponseEntity<Map<String, String>> loginWithInjection(String nomeCliente, String senha) {
        Map<String, String> resposta = new HashMap<>();
        Optional<Cliente> busca = this.clienteCustomRepository.findByNomeClienteAndSenha(nomeCliente, senha);
        resposta.put("mensagem", busca.isPresent() ? "Login realizado com sucesso!" : "Usuário ou senha incorretos. Tente novamente!");
        return ResponseEntity.status(busca.isPresent() ? HttpStatus.OK : HttpStatus.NOT_FOUND).body(resposta);
    }
}
