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
    public class PhieuXuat_64131856Controller : Controller
    {
        private MILANO_64131856Entities db = new MILANO_64131856Entities();

        // GET: PhieuXuat_64131856
        public ActionResult Index()
        {
            return View(db.PhieuXuats.ToList());
        }

        // GET: PhieuXuat_64131856/Details/5
        public ActionResult Details(string id)
        {
            if (id == null)
            {
                return new HttpStatusCodeResult(HttpStatusCode.BadRequest);
            }
            PhieuXuat phieuXuat = db.PhieuXuats.Find(id);
            if (phieuXuat == null)
            {
                return HttpNotFound();
            }
            return View(phieuXuat);
        }

        // GET: PhieuXuat_64131856/Create
        public ActionResult Create()
        {
            return View();
        }

        // POST: PhieuXuat_64131856/Create
        // To protect from overposting attacks, enable the specific properties you want to bind to, for 
        // more details see https://go.microsoft.com/fwlink/?LinkId=317598.
        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult Create([Bind(Include = "MaPhieuXuat,NgayXuat,TongTien")] PhieuXuat phieuXuat)
        {
            if (ModelState.IsValid)
            {
                db.PhieuXuats.Add(phieuXuat);
                db.SaveChanges();
                return RedirectToAction("Index");
            }

            return View(phieuXuat);
        }

        // GET: PhieuXuat_64131856/Edit/5
        public ActionResult Edit(string id)
        {
            if (id == null)
            {
                return new HttpStatusCodeResult(HttpStatusCode.BadRequest);
            }
            PhieuXuat phieuXuat = db.PhieuXuats.Find(id);
            if (phieuXuat == null)
            {
                return HttpNotFound();
            }
            return View(phieuXuat);
        }

        // POST: PhieuXuat_64131856/Edit/5
        // To protect from overposting attacks, enable the specific properties you want to bind to, for 
        // more details see https://go.microsoft.com/fwlink/?LinkId=317598.
        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult Edit([Bind(Include = "MaPhieuXuat,NgayXuat,TongTien")] PhieuXuat phieuXuat)
        {
            if (ModelState.IsValid)
            {
                db.Entry(phieuXuat).State = EntityState.Modified;
                db.SaveChanges();
                return RedirectToAction("Index");
            }
            return View(phieuXuat);
        }

        // GET: PhieuXuat_64131856/Delete/5
        public ActionResult Delete(string id)
        {
            if (id == null)
            {
                return new HttpStatusCodeResult(HttpStatusCode.BadRequest);
            }
            PhieuXuat phieuXuat = db.PhieuXuats.Find(id);
            if (phieuXuat == null)
            {
                return HttpNotFound();
            }
            return View(phieuXuat);
        }

        // POST: PhieuXuat_64131856/Delete/5
        [HttpPost, ActionName("Delete")]
        [ValidateAntiForgeryToken]
        public ActionResult DeleteConfirmed(string id)
        {
            PhieuXuat phieuXuat = db.PhieuXuats.Find(id);
            db.PhieuXuats.Remove(phieuXuat);
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
