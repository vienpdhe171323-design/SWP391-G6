package util;

import java.util.List;

public class PagedResult<T> {
    private final List<T> items;
    private final int total;      // tổng số bản ghi
    private final int page;       // trang hiện tại (1-based)
    private final int pageSize;   // kích thước trang

    public PagedResult(List<T> items, int total, int page, int pageSize) {
        this.items = items;
        this.total = total;
        this.page = page;
        this.pageSize = pageSize;
    }
    public List<T> getItems(){ return items; }
    public int getTotal(){ return total; }
    public int getPage(){ return page; }
    public int getPageSize(){ return pageSize; }
    public int getTotalPages(){ return (int)Math.ceil(total / (double)pageSize); }
    public int getFrom(){ return total==0?0:((page-1)*pageSize+1); }
    public int getTo(){ return Math.min(page*pageSize, total); }
}
