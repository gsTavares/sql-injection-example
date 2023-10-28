package com.sqlinjection.dbsecurity.resource;

import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.sqlinjection.dbsecurity.domain.dto.LoginDTO;
import com.sqlinjection.dbsecurity.service.ClienteService;

@RestController
@RequestMapping(value = "/login", produces = MediaType.APPLICATION_JSON_VALUE)
public class ClienteResource {

    @Autowired
    private ClienteService service;

    @CrossOrigin(origins = "*")
    @PostMapping
    public ResponseEntity<Map<String, String>> login(@RequestBody LoginDTO dto) {
        return this.service.login(dto.getNomeCliente(), dto.getSenha());
    }

    @CrossOrigin(origins = "*")
    @PostMapping(value = "/with-injection")
    public ResponseEntity<Map<String, String>> loginWithInjection(@RequestBody LoginDTO dto) {
        return this.service.loginWithInjection(dto.getNomeCliente(), dto.getSenha());
    }

}
