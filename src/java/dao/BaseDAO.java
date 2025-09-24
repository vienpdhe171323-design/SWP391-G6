/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;

import java.util.List;

/**
 *
 * @author ADMIN
 */
public interface BaseDAO<T> {

    boolean add(T entity);

    boolean update(T entity);

    T getById(int id);
    
    List<T> getAll();
}
