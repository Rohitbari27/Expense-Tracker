using System;
using System.Data;
using System.Data.SqlClient;

namespace ExpenseTracker
{
    public partial class index : System.Web.UI.Page
    {
        SqlConnection conn = new SqlConnection("Data Source=ROHIT\\SQLEXPRESS;Initial Catalog=expense_tracker;Integrated Security=True");

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                BindGrid();
                BindTotal();
            }
        }

        protected void btnAdd_Click(object sender, EventArgs e)
        {
            if (string.IsNullOrWhiteSpace(txtTitle.Text) || string.IsNullOrWhiteSpace(txtAmount.Text))
            {
                Response.Write("<script>alert('Please enter both Title and Amount');</script>");
                return;
            }

            try
            {
                SqlCommand cmd = new SqlCommand("INSERT INTO Expenses (Title, Amount, DateAdded) VALUES (@Title, @Amount, @DateAdded)", conn);
                cmd.Parameters.AddWithValue("@Title", txtTitle.Text.Trim());
                cmd.Parameters.AddWithValue("@Amount", Convert.ToDecimal(txtAmount.Text.Trim()));
                cmd.Parameters.AddWithValue("@DateAdded", DateTime.Now);

                conn.Open();
                cmd.ExecuteNonQuery();
                conn.Close();

                txtTitle.Text = "";
                txtAmount.Text = "";

                BindGrid(txtSearch.Text.Trim());
                BindTotal();

                Response.Write("<script>alert('Amount entered successfully!');</script>");
            }
            catch (Exception ex)
            {
                Response.Write("<script>alert('Error: " + ex.Message + "');</script>");
            }
        }

        protected void btnSearch_Click(object sender, EventArgs e)
        {
            BindGrid(txtSearch.Text.Trim());
        }

        private void BindGrid(string search = "")
        {
            SqlCommand cmd;

            if (!string.IsNullOrWhiteSpace(search))
            {
                cmd = new SqlCommand("SELECT * FROM Expenses WHERE Title LIKE @Search ORDER BY DateAdded DESC", conn);
                cmd.Parameters.AddWithValue("@Search", "%" + search + "%");
            }
            else
            {
                cmd = new SqlCommand("SELECT * FROM Expenses ORDER BY DateAdded DESC", conn);
            }

            SqlDataAdapter da = new SqlDataAdapter(cmd);
            DataTable dt = new DataTable();
            da.Fill(dt);

            GridView1.DataSource = dt;
            GridView1.DataBind();
        }

        private void BindTotal()
        {
            // Overall Total
            SqlCommand totalCmd = new SqlCommand("SELECT SUM(Amount) FROM Expenses", conn);
            conn.Open();
            object totalResult = totalCmd.ExecuteScalar();
            conn.Close();

            lblTotal.Text = totalResult != DBNull.Value ? Convert.ToDecimal(totalResult).ToString("0.00") : "0.00";

            // Today's Total
            SqlCommand todayCmd = new SqlCommand("SELECT SUM(Amount) FROM Expenses WHERE CAST(DateAdded AS DATE) = CAST(GETDATE() AS DATE)", conn);
            conn.Open();
            object todayResult = todayCmd.ExecuteScalar();
            conn.Close();

            lblTodayTotal.Text = todayResult != DBNull.Value ? Convert.ToDecimal(todayResult).ToString("0.00") : "0.00";
        }

    }
}
