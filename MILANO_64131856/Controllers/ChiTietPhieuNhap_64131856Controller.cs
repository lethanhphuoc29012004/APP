using System;
using System.Collections.Generic;
using System.Data;
using System.Data.Entity;
using System.Linq;
using System.Net;
using System.Web;
using System.Web.Mvc;
using MILANO_64131856.Models;

namespace MILANO_64131856.Controllers
{
    public class ChiTietPhieuNhap_64131856Controller : Controller
    {
        private MILANO_64131856Entities db = new MILANO_64131856Entities();

        // GET: ChiTietPhieuNhap_64131856
        public ActionResult Index()
        {
            var chiTietPhieuNhaps = db.ChiTietPhieuNhaps.Include(c => c.PhieuNhap).Include(c => c.SanPham);
            return View(chiTietPhieuNhaps.ToList());
        }

        // GET: ChiTietPhieuNhap_64131856/Details/5
        public ActionResult Details(string id)
        {
            if (id == null)
            {
                return new HttpStatusCodeResult(HttpStatusCode.BadRequest);
            }
            ChiTietPhieuNhap chiTietPhieuNhap = db.ChiTietPhieuNhaps.Find(id);
            if (chiTietPhieuNhap == null)
            {
                return HttpNotFound();
            }
            return View(chiTietPhieuNhap);
        }

        // GET: ChiTietPhieuNhap_64131856/Create
        public ActionResult Create()
        {
            ViewBag.MaPhieuNhap = new SelectList(db.PhieuNhaps, "MaPhieuNhap", "MaPhieuNhap");
            ViewBag.MaSanPham = new SelectList(db.SanPhams, "MaSanPham", "TenSanPham");
            return View();
        }

        // POST: ChiTietPhieuNhap_64131856/Create
        // To protect from overposting attacks, enable the specific properties you want to bind to, for 
        // more details see https://go.microsoft.com/fwlink/?LinkId=317598.
        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult Create([Bind(Include = "MaChiTietNhap,MaPhieuNhap,MaSanPham,SoLuong,DonGia,ThanhTien")] ChiTietPhieuNhap chiTietPhieuNhap)
        {
            if (ModelState.IsValid)
            {
                db.ChiTietPhieuNhaps.Add(chiTietPhieuNhap);
                db.SaveChanges();
                // Cập nhật SoLuongTon của sản phẩm
                var sanPham = db.SanPhams.FirstOrDefault(sp => sp.MaSanPham == chiTietPhieuNhap.MaSanPham);
                if (sanPham != null)
                {
                    sanPham.SoLuongTon += chiTietPhieuNhap.SoLuong; // Cộng số lượng nhập
                    db.SaveChanges();
                }
                ViewBag.Message = "Thêm phiếu nhập thành công và số lượng tồn đã cập nhật!";
                return RedirectToAction("Index");
            }

            ViewBag.MaPhieuNhap = new SelectList(db.PhieuNhaps, "MaPhieuNhap", "MaPhieuNhap", chiTietPhieuNhap.MaPhieuNhap);
            ViewBag.MaSanPham = new SelectList(db.SanPhams, "MaSanPham", "TenSanPham", chiTietPhieuNhap.MaSanPham);
            return View(chiTietPhieuNhap);
        }

        // GET: ChiTietPhieuNhap_64131856/Edit/5
        public ActionResult Edit(string id)
        {
            if (id == null)
            {
                return new HttpStatusCodeResult(HttpStatusCode.BadRequest);
            }
            ChiTietPhieuNhap chiTietPhieuNhap = db.ChiTietPhieuNhaps.Find(id);
            if (chiTietPhieuNhap == null)
            {
                return HttpNotFound();
            }
            ViewBag.MaPhieuNhap = new SelectList(db.PhieuNhaps, "MaPhieuNhap", "MaPhieuNhap", chiTietPhieuNhap.MaPhieuNhap);
            ViewBag.MaSanPham = new SelectList(db.SanPhams, "MaSanPham", "TenSanPham", chiTietPhieuNhap.MaSanPham);
            return View(chiTietPhieuNhap);
        }

        // POST: ChiTietPhieuNhap_64131856/Edit/5
        // To protect from overposting attacks, enable the specific properties you want to bind to, for 
        // more details see https://go.microsoft.com/fwlink/?LinkId=317598.
        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult Edit([Bind(Include = "MaChiTietNhap,MaPhieuNhap,MaSanPham,SoLuong,DonGia,ThanhTien")] ChiTietPhieuNhap chiTietPhieuNhap)
        {
            if (ModelState.IsValid)
            {
                db.Entry(chiTietPhieuNhap).State = EntityState.Modified;
                db.SaveChanges();
                return RedirectToAction("Index");
            }
            ViewBag.MaPhieuNhap = new SelectList(db.PhieuNhaps, "MaPhieuNhap", "MaPhieuNhap", chiTietPhieuNhap.MaPhieuNhap);
            ViewBag.MaSanPham = new SelectList(db.SanPhams, "MaSanPham", "TenSanPham", chiTietPhieuNhap.MaSanPham);
            return View(chiTietPhieuNhap);
        }

        // GET: ChiTietPhieuNhap_64131856/Delete/5
        public ActionResult Delete(string id)
        {
            if (id == null)
            {
                return new HttpStatusCodeResult(HttpStatusCode.BadRequest);
            }
            ChiTietPhieuNhap chiTietPhieuNhap = db.ChiTietPhieuNhaps.Find(id);
            if (chiTietPhieuNhap == null)
            {
                return HttpNotFound();
            }
            return View(chiTietPhieuNhap);
        }

        // POST: ChiTietPhieuNhap_64131856/Delete/5
        [HttpPost, ActionName("Delete")]
        [ValidateAntiForgeryToken]
        public ActionResult DeleteConfirmed(string id)
        {
            ChiTietPhieuNhap chiTietPhieuNhap = db.ChiTietPhieuNhaps.Find(id);
            db.ChiTietPhieuNhaps.Remove(chiTietPhieuNhap);
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
    }
}
