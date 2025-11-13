using System;
using System.Collections.Generic;
using System.Data;
using System.Data.Entity;
using System.Linq;
using System.Net;
using System.Web;
using System.Web.Mvc;
using ThueXeTrucTuyen.Models;

namespace ThueXeTrucTuyen.Controllers
{
    public class DanhGiasController : Controller
    {
        private ThueXeTrucTuyenEntities db = new ThueXeTrucTuyenEntities();

        // GET: DanhGias
        public ActionResult Index()
        {
            var danhGias = db.DanhGias.Include(d => d.KhachHang).Include(d => d.Xe);
            return View(danhGias.ToList());
        }

        // GET: DanhGias/Details/5
        public ActionResult Details(int? id)
        {
            if (id == null)
            {
                return new HttpStatusCodeResult(HttpStatusCode.BadRequest);
            }
            DanhGia danhGia = db.DanhGias.Find(id);
            if (danhGia == null)
            {
                return HttpNotFound();
            }
            return View(danhGia);
        }

        // GET: DanhGias/Create
        public ActionResult Create()
        {
            ViewBag.id_khach_hang = new SelectList(db.KhachHangs, "id", "ho_ten");
            ViewBag.id_xe = new SelectList(db.Xes, "id", "ten_xe");
            return View();
        }

        // POST: DanhGias/Create
        // To protect from overposting attacks, enable the specific properties you want to bind to, for 
        // more details see https://go.microsoft.com/fwlink/?LinkId=317598.
        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult Create([Bind(Include = "id,id_khach_hang,id_xe,so_sao,binh_luan,ngay_danh_gia")] DanhGia danhGia)
        {
            if (ModelState.IsValid)
            {
                db.DanhGias.Add(danhGia);
                db.SaveChanges();
                return RedirectToAction("Index");
            }

            ViewBag.id_khach_hang = new SelectList(db.KhachHangs, "id", "ho_ten", danhGia.id_khach_hang);
            ViewBag.id_xe = new SelectList(db.Xes, "id", "ten_xe", danhGia.id_xe);
            return View(danhGia);
        }

        // GET: DanhGias/Edit/5
        public ActionResult Edit(int? id)
        {
            if (id == null)
            {
                return new HttpStatusCodeResult(HttpStatusCode.BadRequest);
            }
            DanhGia danhGia = db.DanhGias.Find(id);
            if (danhGia == null)
            {
                return HttpNotFound();
            }
            ViewBag.id_khach_hang = new SelectList(db.KhachHangs, "id", "ho_ten", danhGia.id_khach_hang);
            ViewBag.id_xe = new SelectList(db.Xes, "id", "ten_xe", danhGia.id_xe);
            return View(danhGia);
        }

        // POST: DanhGias/Edit/5
        // To protect from overposting attacks, enable the specific properties you want to bind to, for 
        // more details see https://go.microsoft.com/fwlink/?LinkId=317598.
        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult Edit([Bind(Include = "id,id_khach_hang,id_xe,so_sao,binh_luan,ngay_danh_gia")] DanhGia danhGia)
        {
            if (ModelState.IsValid)
            {
                db.Entry(danhGia).State = EntityState.Modified;
                db.SaveChanges();
                return RedirectToAction("Index");
            }
            ViewBag.id_khach_hang = new SelectList(db.KhachHangs, "id", "ho_ten", danhGia.id_khach_hang);
            ViewBag.id_xe = new SelectList(db.Xes, "id", "ten_xe", danhGia.id_xe);
            return View(danhGia);
        }

        // GET: DanhGias/Delete/5
        public ActionResult Delete(int? id)
        {
            if (id == null)
            {
                return new HttpStatusCodeResult(HttpStatusCode.BadRequest);
            }
            DanhGia danhGia = db.DanhGias.Find(id);
            if (danhGia == null)
            {
                return HttpNotFound();
            }
            return View(danhGia);
        }

        // POST: DanhGias/Delete/5
        [HttpPost, ActionName("Delete")]
        [ValidateAntiForgeryToken]
        public ActionResult DeleteConfirmed(int id)
        {
            DanhGia danhGia = db.DanhGias.Find(id);
            db.DanhGias.Remove(danhGia);
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
