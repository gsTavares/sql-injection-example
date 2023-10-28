package com.sqlinjection.dbsecurity.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;

import com.sqlinjection.dbsecurity.repository.ProdutoRepository;

@Service
public class ProdutoService {

    @Autowired
    private ProdutoRepository repository;

    public ResponseEntity<Object> list() {
        return ResponseEntity.ok(repository.findAll());
    }


    
}
