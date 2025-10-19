package entity;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.List;

public class Cart {
    private List<CartItem> items;

    public Cart() {
        this.items = new ArrayList<>();
    }

    // Thêm sản phẩm vào giỏ hàng
    public void addItem(CartItem item) {
        for (CartItem existingItem : items) {
            if (existingItem.getProductId() == item.getProductId()) {
                existingItem.setQuantity(existingItem.getQuantity() + item.getQuantity());
                return;
            }
        }
        items.add(item);
    }

    // Lấy danh sách mục trong giỏ
    public List<CartItem> getItems() {
        return items;
    }

    // Tính tổng số lượng sản phẩm
    public int getTotalQuantity() {
        return items.stream().mapToInt(CartItem::getQuantity).sum();
    }

    // Tính tổng giá trị giỏ hàng
    public BigDecimal getTotalPrice() {
        return items.stream()
                .map(CartItem::getTotalPrice)
                .reduce(BigDecimal.ZERO, BigDecimal::add);
    }

    // Xóa mục khỏi giỏ hàng
    public void removeItem(int productId) {
        items.removeIf(item -> item.getProductId() == productId);
    }

    // Xóa toàn bộ giỏ hàng
    public void clear() {
        items.clear();
    }
}