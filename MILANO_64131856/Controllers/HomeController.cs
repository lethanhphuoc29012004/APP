using System;
using System.Collections.Generic;
using System.Data.Entity.Infrastructure;
using System.Data.SqlClient;
using System.Linq;
using System.Security.Cryptography;
using System.Text;
using System.Web;
using System.Web.Mvc;
using System.Web.Security;
using MILANO_64131856.Models; // Nếu SystemDatabase nằm trong namespace này
namespace MILANO_64131856.Controllers
{
    public class HomeController : Controller
    {
        
        public ActionResult Index()
        {
            if (Session["user"] == null)
            {
                return RedirectToAction("DangNhap_64131856");

            }
            else return View();

        }
        public ActionResult IndexStaff()
        {
            if (Session["user"] == null)
            {
                return RedirectToAction("DangNhap_64131856");

            }
            else return View();

        }

        public ActionResult DangNhap_64131856()
        {
            return View();
        }
        [HttpPost]
        public ActionResult DangNhap_64131856(string user, string password)
        {
            // Chuỗi kết nối từ web.config
            string connectionString = System.Configuration.ConfigurationManager.ConnectionStrings["DefaultConnection"].ToString();

            try
            {
                // Kiểm tra tài khoản admin cố định
                if (user == "admin" && password == "admin123")
                {
                    Session["user"] = user; // Lưu thông tin vào Session
                    return RedirectToAction("Index", "Home"); // Chuyển hướng về Home/Index
                }

                // Kiểm tra tài khoản còn lại trong database
                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    conn.Open();
                    string query = "SELECT COUNT(1) FROM Account WHERE Username = @Username AND Pass = @Password";
                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        // Thêm tham số để tránh SQL Injection
                        cmd.Parameters.AddWithValue("@Username", user);
                        cmd.Parameters.AddWithValue("@Password", password);

                        int result = (int)cmd.ExecuteScalar(); // Kiểm tra kết quả trả về

                        if (result == 1) // Tài khoản khác đúng thông tin
                        {
                            Session["user"] = user; // Lưu thông tin vào Session
                            return RedirectToAction("IndexStaff", "Home"); // Chuyển hướng về Home/IndexStaff
                        }
                        else
                        {
                            TempData["Error"] = "Tài khoản hoặc mật khẩu không đúng";
                            return View();
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                TempData["Error"] = "Có lỗi xảy ra: " + ex.Message;
                return View();
            }
        }

       

        public ActionResult DangXuat()
        {
            //xóa session
            Session.Remove("user");
            //Xóa session form
            FormsAuthentication.SignOut();
            return RedirectToAction("DangNhap");
        }

    }
}