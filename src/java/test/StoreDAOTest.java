package test;

import dao.StoreDAO;
import entity.Store;
import java.util.Date;
import java.util.List;
import java.util.Map;

public class StoreDAOTest {

    public static void main(String[] args) {

        StoreDAO dao = new StoreDAO();

        System.out.println("===== TEST 1: getTopStores(5) =====");
        List<Store> topStores = dao.getTopStores(5);
        topStores.forEach(s ->
                System.out.println(s.getStoreId() + " | " + s.getStoreName())
        );

        System.out.println("\n===== TEST 2: getAllStores() =====");
        List<Store> allStores = dao.getAllStores();
        allStores.forEach(s ->
                System.out.println(s.getStoreId() + " | " + s.getStoreName() + " | Status: " + s.getStatus())
        );

        System.out.println("\n===== TEST 3: getAllStoresWithPaging(page=1) =====");
        List<Store> pageStores = dao.getAllStoresWithPaging(1);
        pageStores.forEach(s ->
                System.out.println("ID: " + s.getStoreId()
                        + " | Name: " + s.getStoreName()
                        + " | Owner: " + s.getOwnerName())
        );

        System.out.println("\n===== TEST 4: countAllStores() =====");
        System.out.println("Total: " + dao.countAllStores());

        System.out.println("\n===== TEST 5: getStoresByUserWithPaging(userId=1, page=1) =====");
        List<Store> storesByUser = dao.getStoresByUserWithPaging(1, 1);
        storesByUser.forEach(s ->
                System.out.println(s.getStoreId() + " | " + s.getStoreName())
        );

        System.out.println("\n===== TEST 6: countStoresByUser(1) =====");
        System.out.println("User 1 store count: " + dao.countStoresByUser(1));

        System.out.println("\n===== TEST 7: createStore() =====");
        Store newStore = new Store();
        newStore.setUserId(1);
        newStore.setStoreName("Test Store ABC");
        newStore.setCreatedAt(new Date());
        newStore.setStatus("Active");
        boolean created = dao.createStore(newStore);
        System.out.println("Create store result: " + created);

        System.out.println("\n===== TEST 8: getStoreById(1) =====");
        Store s1 = dao.getStoreById(1);
        if (s1 != null) {
            System.out.println("Found store: " + s1.getStoreName()
                    + " | Owner: " + s1.getOwnerName());
        } else {
            System.out.println("Not found ID=1");
        }

        System.out.println("\n===== TEST 9: updateStore() =====");
        if (s1 != null) {
            s1.setStoreName("Updated Name X");
            s1.setStatus("Suspended");
            boolean updated = dao.updateStore(s1);
            System.out.println("Update result: " + updated);
        }

        System.out.println("\n===== TEST 10: searchStoresByName(\"Test\") =====");
        List<Store> searchResult = dao.searchStoresByName("Test");
        searchResult.forEach(s ->
                System.out.println(s.getStoreId() + " | " + s.getStoreName())
        );

        System.out.println("\n===== TEST 11: updateStatus(1, \"Active\") =====");
        dao.updateStatus(1, "Active");
        System.out.println("Updated store 1 to ACTIVE");

        System.out.println("\n===== TEST 12: deleteStore(9999) =====");
        boolean del = dao.deleteStore(9999);
        System.out.println("Delete result: " + del);

        System.out.println("\n===== TEST 13: getProductCountOfStores() =====");
        Map<Integer, Integer> storeProducts = dao.getProductCountOfStores();
        storeProducts.forEach((storeId, count) ->
                System.out.println("Store " + storeId + " → Products: " + count)
        );

        System.out.println("\n===== END TEST =====");
    }
}
