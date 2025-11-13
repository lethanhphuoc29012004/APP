using System;
using System.Collections.Generic;
using System.Data;
using System.Data.Entity;
using System.Linq;
using System.Net;
using System.Web;
using System.Web.Mvc;
using System.Web.Security;
using MILANO_64131856.Models;

namespace MILANO_64131856.Controllers
{
    public class SanPham_64131856Controller : Controller
    {
        private MILANO_64131856Entities db = new MILANO_64131856Entities();

        // GET: SanPham_64131856
        public ActionResult Index()
        {
            var sanPhams = db.SanPhams.Include(s => s.LoaiSanPham);
            return View(sanPhams.ToList());
        }

        // GET: SanPham_64131856/Details/5
        public ActionResult Details(string id)
        {
            if (id == null)
            {
                return new HttpStatusCodeResult(HttpStatusCode.BadRequest);
            }
            SanPham sanPham = db.SanPhams.Find(id);
            if (sanPham == null)
            {
                return HttpNotFound();
            }
            return View(sanPham);
        }

        // GET: SanPham_64131856/Create
        public ActionResult Create()
        {
            ViewBag.MaLoai = new SelectList(db.LoaiSanPhams, "MaLoai", "TenLoai");
            return View();
        }

        // POST: SanPham_64131856/Create
        // To protect from overposting attacks, enable the specific properties you want to bind to, for 
        // more details see https://go.microsoft.com/fwlink/?LinkId=317598.
        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult Create([Bind(Include = "MaSanPham,TenSanPham,MaLoai,GiaBan,SoLuongTon,AnhSanPham")] SanPham sanPham)
        {
            //System.Web.HttpPostedFileBase Avatar;
            var img = Request.Files["Avatar"];
            //Lấy thông tin từ input type=file có tên Avatar
            string postedFileName = System.IO.Path.GetFileName(img.FileName);
            //Lưu hình đại diện về Server
            var path = Server.MapPath("/Images/" + postedFileName);
            img.SaveAs(path);
            if (ModelState.IsValid)
            {
                sanPham.AnhSanPham = postedFileName;
                db.SanPhams.Add(sanPham);
                db.SaveChanges();
                return RedirectToAction("Index");
            }

            ViewBag.MaLoai = new SelectList(db.LoaiSanPhams, "MaLoai", "TenLoai", sanPham.MaLoai);
            return View(sanPham);
        }

        // GET: SanPham_64131856/Edit/5
        public ActionResult Edit(string id)
        {
            if (id == null)
            {
                return new HttpStatusCodeResult(HttpStatusCode.BadRequest);
            }
            SanPham sanPham = db.SanPhams.Find(id);
            if (sanPham == null)
            {
                return HttpNotFound();
            }
            ViewBag.MaLoai = new SelectList(db.LoaiSanPhams, "MaLoai", "TenLoai", sanPham.MaLoai);
            return View(sanPham);
        }

        // POST: SanPham_64131856/Edit/5
        // To protect from overposting attacks, enable the specific properties you want to bind to, for 
        // more details see https://go.microsoft.com/fwlink/?LinkId=317598.
        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult Edit([Bind(Include = "MaSanPham,TenSanPham,MaLoai,GiaBan,SoLuongTon,AnhSanPham")] SanPham sanPham)
        {

            if (ModelState.IsValid)
            {

                db.Entry(sanPham).State = EntityState.Modified;
                db.SaveChanges();
                return RedirectToAction("Index");
            }
            ViewBag.MaLoai = new SelectList(db.LoaiSanPhams, "MaLoai", "TenLoai", sanPham.MaLoai);
            return View(sanPham);
        }

        // GET: SanPham_64131856/Delete/5
        public ActionResult Delete(string id)
        {
            if (id == null)
            {
                return new HttpStatusCodeResult(HttpStatusCode.BadRequest);
            }
            SanPham sanPham = db.SanPhams.Find(id);
            if (sanPham == null)
            {
                return HttpNotFound();
            }
            return View(sanPham);
        }

        // POST: SanPham_64131856/Delete/5
        [HttpPost, ActionName("Delete")]
        [ValidateAntiForgeryToken]
        public ActionResult DeleteConfirmed(string id)
        {
            SanPham sanPham = db.SanPhams.Find(id);
            db.SanPhams.Remove(sanPham);
            db.SaveChanges();
            return RedirectToAction("Index");
        }

        protected override void Dispose(bool disposing)
        {
            if (disposing)
            {
                db.Dispose();
            }
            base.Dispose(disposing);
        }
        public ActionResult TimKiemSanPham_64131856(string maSanPham = "", string tenSanPham = "")
        {
            ViewBag.maSanPham = maSanPham;
            ViewBag.tenSanPham = tenSanPham;


            // Gọi stored procedure SanPham_TimKiem với các tham số tìm kiếm
            var sanPhams = db.SanPhams.SqlQuery("SanPham_TimKiem'" + maSanPham + "', '" + tenSanPham + "'");

            if (!sanPhams.Any())
                ViewBag.TB = "Không có thông tin tìm kiếm.";

            return View(sanPhams.ToList());
        }
        public ActionResult BaoCao_64131856()
        {
            // Lấy danh sách sản phẩm từ cơ sở dữ liệu và thực hiện các phép toán trên bộ nhớ
            var products = db.SanPhams
                .AsEnumerable()  // Chuyển đổi sang IEnumerable để thực hiện phép toán trên bộ nhớ
                .Select(s => new Product_64131856
                {
                    TenSanPham = s.TenSanPham,
                    SoLuongTon = s.SoLuongTon ?? 0,  // Sử dụng giá trị mặc định nếu null
                    TongTienTon = (decimal)((s.GiaBan ?? 0) * (s.SoLuongTon ?? 0))  // Ép kiểu rõ ràng sang decimal
                }).ToList();

            // Tính tổng số lượng tồn và tổng tiền tồn
            int tongSoLuongTon = products.Sum(p => p.SoLuongTon);
            decimal tongTienTon = products.Sum(p => p.TongTienTon);

            // Tạo ViewModel để truyền dữ liệu vào view
            var viewModel = new BaoCao_64131856
            {
                Products = products,
                TongSoLuongTon = tongSoLuongTon,
                TongTienTon = tongTienTon
            };

            return View(viewModel);
        }

    }
}
