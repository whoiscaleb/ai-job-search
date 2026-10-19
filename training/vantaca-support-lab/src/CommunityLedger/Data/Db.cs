using System.Data;
using Microsoft.Data.SqlClient;

namespace CommunityLedger.Data;

/// <summary>Opens connections to the CommunityLab database.</summary>
public static class Db
{
    // Docker default. On Windows with LocalDB, set the LAB_CONNECTION_STRING environment variable to:
    //   Server=(localdb)\MSSQLLocalDB;Database=CommunityLab;Trusted_Connection=True;TrustServerCertificate=True
    private const string DefaultConnectionString =
        "Server=localhost,1433;Database=CommunityLab;User Id=sa;Password=Lab_Passw0rd!;TrustServerCertificate=True";

    public static string ConnectionString =>
        Environment.GetEnvironmentVariable("LAB_CONNECTION_STRING") ?? DefaultConnectionString;

    public static SqlConnection Open()
    {
        var conn = new SqlConnection(ConnectionString);
        conn.Open();
        return conn;
    }

    /// <summary>Runs a stored procedure and returns its first result set.</summary>
    public static DataTable ExecProc(string procName, params (string Name, object Value)[] parameters)
    {
        using var conn = Open();
        using var cmd = new SqlCommand(procName, conn) { CommandType = CommandType.StoredProcedure };
        foreach (var (name, value) in parameters)
            cmd.Parameters.AddWithValue(name, value);

        var table = new DataTable();
        using var reader = cmd.ExecuteReader();
        table.Load(reader);
        return table;
    }
}
