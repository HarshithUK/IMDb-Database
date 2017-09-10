package imdb.ui;
import java.sql.DriverManager;
import java.sql.Connection;
import java.sql.SQLException;
import java.sql.Types;
import java.sql.*;
import java.util.Scanner;
public class ImdbUI {
    public static void main(String[] args) {
        try
        {
            Class.forName("org.postgresql.Driver");

        }
        catch (ClassNotFoundException e)
        {
            System.out.println("Where is your PostgreSQL JDBC Driver? "+"Include in your library path!");
            e.printStackTrace();
            return;
        }
        Connection connection = null;
        try
        {
            connection = DriverManager.getConnection(
                    "jdbc:postgresql://127.0.0.1:5432/"
                            + "postgres", "postgres",
                    "abc123");

        }
        catch (SQLException e)
        {
            System.out.println("Connection Failed! Check output console");
            e.printStackTrace();
            return;
        }
        if (connection != null)
        {
            System.out.println("You are connected to the database");
        }
        else
        {
            System.out.println("Failed to make connection!");
        }
        retrieve(connection);
        if(connection==null)
        {
            connection.close();
        }
    }
    
    public static void retrieve(Connection conn)
    {
        Statement stmt = null;
        Scanner in = new Scanner(System.in);
        int ch=0;
        System.out.println("\t----WELCOME TO IMDB-----");
        try
        {
            do
            {
                System.out.println("1.Insert");
                System.out.println("2.Delete");
                System.out.println("3.Update");
                System.out.println("4.Search");
                System.out.println("5.Exit");
                do
                {
                    System.out.print("\nType a valid option: ");
                    ch = in.nextInt();
                }
                while(ch<1 && ch>6);
                if(ch==1)
                {
                    stmt = conn.createStatement();
                    System.out.println("In which table you want to insert?");
                    String table = in.next();
                    String sql = "select * from "+table+"";
                    ResultSet rs = stmt.executeQuery(sql);
                    ResultSetMetaData rsmd = rs.getMetaData();
                    int columnCount = rsmd.getColumnCount();
                    int[] datatype = new int[columnCount];
                    for (int i = 1; i <= columnCount; i++ ) {
                        String name = rsmd.getColumnName(i);
                        System.out.print(name);
                        if(i!=columnCount)
                        {
                            System.out.print(",");
                        }
                        else
                        {
                            System.out.println();
                        }
                        datatype[i-1] = rsmd.getColumnType(i);
                    }
                    System.out.println("Enter the data in the above order: ");
                    String input = in.nextLine();
                    input = in.nextLine();
                    String[] iarray = input.split(",");
                    sql = "insert into "+table+" values (";
                    for(int j=0; j<iarray.length; ++j)
                    {
                        if(datatype[j]==Types.VARCHAR || datatype[j]==Types.CHAR)
                        {
                            sql += "'"+iarray[j]+"'";
                        }
                        else
                        {
                            sql += "" + iarray[j] + "";
                        }
                        if(j!=iarray.length-1)
                        {
                            sql += ',';
                        }
                    }
                    sql += ")";
                    stmt.execute(sql);
                    System.out.println("Data is inserted into the table "+table+" successfully!");
                    rs.close();
                }
                else if(ch==2)
                {
                    stmt = conn.createStatement();
                    System.out.println("From which table do you want to remove?");
                    String table = in.next();
                    String sql = "delete from "+table+"";
                    System.out.println("Do you want to add any contstraint(Y/N)");
                    String c = in.next();
                    if(c.equals("Y"))
                    {
                        System.out.println("Type the constraint here :");
                        c = in.nextLine();
                        c = in.nextLine();
                        sql += " where "+c;
                    }
                    stmt.execute(sql);
                    System.out.println("Data is deleted from the table "+table+" successfully!\n");
                }
                else if(ch==3)
                {
                    stmt = conn.createStatement();
                    System.out.println("Which table do you want to update?");
                    String table = in.next();
                    String sql = "update "+table;
                    System.out.println("Type the constarint of the tuples with which you want to update:");
                    String constr = in.nextLine();
                    constr = in.nextLine();
                    System.out.println("What constraint do you set them with?");
                    String setcons = in.nextLine();
                    sql += " set "+setcons+" where "+constr;
                    stmt.execute(sql);
                    System.out.println("Data is updated on the table "+table+" successfully!\n");
                }
                else if(ch==4)
                {
                    stmt = conn.createStatement();
                    System.out.println("Which table do you want to select?");
                    String table = in.next();
                    String sql = "select * from "+table+"";
                    ResultSet rs = stmt.executeQuery(sql);
                    ResultSetMetaData rsmd = rs.getMetaData();
                    int columnCount = rsmd.getColumnCount();
                    for (int i = 1; i <= columnCount; i++ ) {
                        String name = rsmd.getColumnName(i);
                        System.out.print(name);
                        if(i!=columnCount)
                        {
                            System.out.print(",");
                        }
                        else
                        {
                            System.out.println();
                        }
                    }
                    System.out.println("Type the column names you want to execute:");
                    String cnames = in.nextLine();
                    cnames = in.nextLine();
                    String[] columns = cnames.split(" ");
                    sql = "select ";
                    for(int i=0; i<columns.length; ++i)
                    {
                        sql += columns[i];
                        if(i!=columns.length-1)
                        {
                            sql += ",";
                        }
                    }
                    sql += " from " + table;
                    System.out.println("Do you want to add any specific constraint?(Y/N)");
                    String constr = in.next();
                    if(constr.equals("Y"))
                    {
                        System.out.println("Type the constraint here :");
                        constr = in.nextLine();
                        constr = in.nextLine();
                        sql += " where "+constr;
                    }
                    rs = stmt.executeQuery(sql);
                    rsmd = rs.getMetaData();
                    while(rs.next())
                    {
                        for(int i=0; i<columns.length; ++i)
                        {
                            String name = rsmd.getColumnName(i+1);
                            String f = rs.getString(name);
                            System.out.print(f);
                            if(i!=columns.length-1)
                            {
                                System.out.print("\t");
                            }
                        }
                        System.out.println();
                    }
                    rs.close();
                }
            }
            while(ch!=5);
        }
        catch(Exception e)
        {
            System.out.println(e);
            e.printStackTrace();
        }
    }
}
