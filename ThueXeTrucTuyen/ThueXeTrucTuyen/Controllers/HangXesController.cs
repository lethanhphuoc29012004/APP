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
    public class HangXesController : Controller
    {
        private ThueXeTrucTuyenEntities db = new ThueXeTrucTuyenEntities();

        // GET: HangXes
        public ActionResult Index()
        {
            return View(db.HangXes.ToList());
        }

        // GET: HangXes/Details/5
        public ActionResult Details(int? id)
        {
            if (id == null)
            {
                return new HttpStatusCodeResult(HttpStatusCode.BadRequest);
            }
            HangXe hangXe = db.HangXes.Find(id);
            if (hangXe == null)
            {
                return HttpNotFound();
            }
            return View(hangXe);
        }

        // GET: HangXes/Create
        public ActionResult Create()
        {
            return View();
        }

        // POST: HangXes/Create
        // To protect from overposting attacks, enable the specific properties you want to bind to, for 
        // more details see https://go.microsoft.com/fwlink/?LinkId=317598.
        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult Create([Bind(Include = "id,ten_hang,quoc_gia")] HangXe hangXe)
        {
            if (ModelState.IsValid)
            {
                db.HangXes.Add(hangXe);
                db.SaveChanges();
                return RedirectToAction("Index");
            }

            return View(hangXe);
        }

        // GET: HangXes/Edit/5
        public ActionResult Edit(int? id)
        {
            if (id == null)
            {
                return new HttpStatusCodeResult(HttpStatusCode.BadRequest);
            }
            HangXe hangXe = db.HangXes.Find(id);
            if (hangXe == null)
            {
                return HttpNotFound();
            }
            return View(hangXe);
        }

        // POST: HangXes/Edit/5
        // To protect from overposting attacks, enable the specific properties you want to bind to, for 
        // more details see https://go.microsoft.com/fwlink/?LinkId=317598.
        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult Edit([Bind(Include = "id,ten_hang,quoc_gia")] HangXe hangXe)
        {
            if (ModelState.IsValid)
            {
                db.Entry(hangXe).State = EntityState.Modified;
                db.SaveChanges();
                return RedirectToAction("Index");
            }
            return View(hangXe);
        }

        // GET: HangXes/Delete/5
        public ActionResult Delete(int? id)
        {
            if (id == null)
            {
                return new HttpStatusCodeResult(HttpStatusCode.BadRequest);
            }
            HangXe hangXe = db.HangXes.Find(id);
            if (hangXe == null)
            {
                return HttpNotFound();
            }
            return View(hangXe);
        }

        // POST: HangXes/Delete/5
        [HttpPost, ActionName("Delete")]
        [ValidateAntiForgeryToken]
        public ActionResult DeleteConfirmed(int id)
        {
            HangXe hangXe = db.HangXes.Find(id);
            db.HangXes.Remove(hangXe);
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
