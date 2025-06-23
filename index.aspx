<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="index.aspx.cs" Inherits="ExpenseTracker.index" %>

<!DOCTYPE html>
<html>
<head runat="server">
    <title>Expense Tracker</title>
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet" />

    <!-- Delay and trigger hidden postback -->
    <script type="text/javascript">
        let timer;
        function delaySearch() {
            clearTimeout(timer);
            timer = setTimeout(function () {
                __doPostBack('<%= btnHiddenSearch.UniqueID %>', '');
            }, 500);
        }
    </script>
</head>
<body>
    <form id="form1" runat="server">
        <asp:ScriptManager ID="ScriptManager1" runat="server" />

        <div class="container mt-5">
            <div class="row justify-content-center">
                <div class="col-12 col-md-8 col-lg-6">
                    <div class="card shadow-lg p-4">
                        <h2 class="text-center mb-4">💸 Expense Tracker</h2>

                        <!-- Add Expense Form -->
                        <div class="form-group mb-3">
                            <asp:TextBox ID="txtTitle" runat="server" CssClass="form-control" placeholder="Expense Title" />
                        </div>
                        <div class="form-group mb-3">
                            <asp:TextBox ID="txtAmount" runat="server" CssClass="form-control" placeholder="Amount ₹" />
                        </div>
                        <div class="form-group mb-3 d-grid">
                            <asp:Button ID="btnAdd" runat="server" Text="➕ Add Expense" CssClass="btn btn-primary btn-block" OnClick="btnAdd_Click" />
                        </div>

                        <!-- Live Search Box -->
                        <div class="input-group mb-3">
                            <asp:TextBox ID="txtSearch" runat="server" CssClass="form-control"
                                onkeyup="delaySearch()" placeholder="🔍 Search by Title" />
                        </div>

                        <!-- Hidden Button for JavaScript postback -->
                        <asp:Button ID="btnHiddenSearch" runat="server" OnClick="btnSearch_Click" Style="display: none;" />

                        <!-- AJAX GridView -->
                        <asp:UpdatePanel ID="UpdatePanel1" runat="server">
                            <ContentTemplate>
                                <div class="table-responsive mt-4">
                                    <asp:GridView ID="GridView1" runat="server" AutoGenerateColumns="False"
                                        CssClass="table table-bordered table-hover table-striped text-center align-middle">
                                        <Columns>
                                            <asp:BoundField DataField="Id" HeaderText="ID" ReadOnly="True" />
                                            <asp:BoundField DataField="Title" HeaderText="Title" />
                                            <asp:BoundField DataField="Amount" HeaderText="Amount" DataFormatString="₹{0:N2}" />
                                            <asp:BoundField DataField="DateAdded" HeaderText="Date" DataFormatString="{0:dd-MMM-yyyy}" />
                                        </Columns>
                                    </asp:GridView>
                                </div>
                            </ContentTemplate>
                        </asp:UpdatePanel>

                        <!-- Total Display -->
                        <div class="text-end mt-3">
                            <h5>🗓️ Today's Total: ₹<asp:Label ID="lblTodayTotal" runat="server" Text="0.00" /></h5>
                            <h5>📊 Overall Total: ₹<asp:Label ID="lblTotal" runat="server" Text="0.00" /></h5>
                        </div>

                    </div>
                </div>
            </div>
        </div>
    </form>
</body>
</html>
