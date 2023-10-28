package com.sqlinjection.dbsecurity.resource;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.sqlinjection.dbsecurity.service.ProdutoService;

@RestController
@RequestMapping(value = "/produto")
public class ProdutoResource {
    
    @Autowired
    private ProdutoService service;

    @CrossOrigin(origins = "*")
    @GetMapping
    public ResponseEntity<Object> list() {
        return service.list();
    }

}
