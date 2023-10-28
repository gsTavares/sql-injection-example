package com.sqlinjection.dbsecurity.domain;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.Table;

@Entity
@Table
public class Pedido {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column
    private Integer numPedido;
    @Column
    private Integer prazoEntrega;
    @JoinColumn
    @ManyToOne
    private Cliente codigoCliente;
    @JoinColumn
    @ManyToOne
    private Vendedor codigoVendedor;

    public Integer getNumPedido() {
        return numPedido;
    }

    public void setNumPedido(Integer numPedido) {
        this.numPedido = numPedido;
    }

    public Integer getPrazoEntrega() {
        return prazoEntrega;
    }

    public void setPrazoEntrega(Integer prazoEntrega) {
        this.prazoEntrega = prazoEntrega;
    }

    public Cliente getCodigoCliente() {
        return codigoCliente;
    }

    public void setCodigoCliente(Cliente codigoCliente) {
        this.codigoCliente = codigoCliente;
    }

    public Vendedor getCodigoVendedor() {
        return codigoVendedor;
    }

    public void setCodigoVendedor(Vendedor codigoVendedor) {
        this.codigoVendedor = codigoVendedor;
    }

}