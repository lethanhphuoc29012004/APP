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
    public class ChiTietPhieuXuatStaff_64131856Controller : Controller
    {
        private MILANO_64131856Entities db = new MILANO_64131856Entities();

        // GET: ChiTietPhieuXuatStaff_64131856
        public ActionResult Index()
        {
            var chiTietPhieuXuats = db.ChiTietPhieuXuats.Include(c => c.PhieuXuat).Include(c => c.SanPham);
            return View(chiTietPhieuXuats.ToList());
        }

        // GET: ChiTietPhieuXuatStaff_64131856/Details/5
        public ActionResult Details(string id)
        {
            if (id == null)
            {
                return new HttpStatusCodeResult(HttpStatusCode.BadRequest);
            }
            ChiTietPhieuXuat chiTietPhieuXuat = db.ChiTietPhieuXuats.Find(id);
            if (chiTietPhieuXuat == null)
            {
                return HttpNotFound();
            }
            return View(chiTietPhieuXuat);
        }

        // GET: ChiTietPhieuXuatStaff_64131856/Create
        public ActionResult Create()
        {
            ViewBag.MaPhieuXuat = new SelectList(db.PhieuXuats, "MaPhieuXuat", "MaPhieuXuat");
            ViewBag.MaSanPham = new SelectList(db.SanPhams, "MaSanPham", "TenSanPham");
            return View();
        }

        // POST: ChiTietPhieuXuatStaff_64131856/Create
        // To protect from overposting attacks, enable the specific properties you want to bind to, for 
        // more details see https://go.microsoft.com/fwlink/?LinkId=317598.
        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult Create([Bind(Include = "MaChiTietXuat,MaPhieuXuat,MaSanPham,SoLuong,DonGia,ThanhTien")] ChiTietPhieuXuat chiTietPhieuXuat)
        {
            if (ModelState.IsValid)
            {
                db.ChiTietPhieuXuats.Add(chiTietPhieuXuat);
                db.SaveChanges();
                // Cập nhật SoLuongTon của sản phẩm
                var sanPham = db.SanPhams.FirstOrDefault(sp => sp.MaSanPham == chiTietPhieuXuat.MaSanPham);
                if (sanPham != null)
                {
                    sanPham.SoLuongTon -= chiTietPhieuXuat.SoLuong; // Trừ số lượng xuất
                    if (sanPham.SoLuongTon < 0) sanPham.SoLuongTon = 0; // Không cho phép âm tồn kho
                    db.SaveChanges();
                }

                ViewBag.Message = "Thêm phiếu xuất thành công và số lượng tồn đã cập nhật!";
                return RedirectToAction("Index");
            }

            ViewBag.MaPhieuXuat = new SelectList(db.PhieuXuats, "MaPhieuXuat", "MaPhieuXuat", chiTietPhieuXuat.MaPhieuXuat);
            ViewBag.MaSanPham = new SelectList(db.SanPhams, "MaSanPham", "TenSanPham", chiTietPhieuXuat.MaSanPham);
            return View(chiTietPhieuXuat);
        }

        // GET: ChiTietPhieuXuatStaff_64131856/Edit/5
        public ActionResult Edit(string id)
        {
            if (id == null)
            {
                return new HttpStatusCodeResult(HttpStatusCode.BadRequest);
            }
            ChiTietPhieuXuat chiTietPhieuXuat = db.ChiTietPhieuXuats.Find(id);
            if (chiTietPhieuXuat == null)
            {
                return HttpNotFound();
            }
            ViewBag.MaPhieuXuat = new SelectList(db.PhieuXuats, "MaPhieuXuat", "MaPhieuXuat", chiTietPhieuXuat.MaPhieuXuat);
            ViewBag.MaSanPham = new SelectList(db.SanPhams, "MaSanPham", "TenSanPham", chiTietPhieuXuat.MaSanPham);
            return View(chiTietPhieuXuat);
        }

        // POST: ChiTietPhieuXuatStaff_64131856/Edit/5
        // To protect from overposting attacks, enable the specific properties you want to bind to, for 
        // more details see https://go.microsoft.com/fwlink/?LinkId=317598.
        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult Edit([Bind(Include = "MaChiTietXuat,MaPhieuXuat,MaSanPham,SoLuong,DonGia,ThanhTien")] ChiTietPhieuXuat chiTietPhieuXuat)
        {
            if (ModelState.IsValid)
            {
                db.Entry(chiTietPhieuXuat).State = EntityState.Modified;
                db.SaveChanges();
                return RedirectToAction("Index");
            }
            ViewBag.MaPhieuXuat = new SelectList(db.PhieuXuats, "MaPhieuXuat", "MaPhieuXuat", chiTietPhieuXuat.MaPhieuXuat);
            ViewBag.MaSanPham = new SelectList(db.SanPhams, "MaSanPham", "TenSanPham", chiTietPhieuXuat.MaSanPham);
            return View(chiTietPhieuXuat);
        }

        // GET: ChiTietPhieuXuatStaff_64131856/Delete/5
        public ActionResult Delete(string id)
        {
            if (id == null)
            {
                return new HttpStatusCodeResult(HttpStatusCode.BadRequest);
            }
            ChiTietPhieuXuat chiTietPhieuXuat = db.ChiTietPhieuXuats.Find(id);
            if (chiTietPhieuXuat == null)
            {
                return HttpNotFound();
            }
            return View(chiTietPhieuXuat);
        }

        // POST: ChiTietPhieuXuatStaff_64131856/Delete/5
        [HttpPost, ActionName("Delete")]
        [ValidateAntiForgeryToken]
        public ActionResult DeleteConfirmed(string id)
        {
            ChiTietPhieuXuat chiTietPhieuXuat = db.ChiTietPhieuXuats.Find(id);
            db.ChiTietPhieuXuats.Remove(chiTietPhieuXuat);
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
