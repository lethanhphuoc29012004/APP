using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;


namespace ThueXeTrucTuyen.Models
{
    public class DoanhThuReport
    {
        public int MaDoanhThu { get; set; } // Tự tăng nếu bạn muốn
        public DateTime Ngay { get; set; }
        public decimal TongTien { get; set; }
    }
}
