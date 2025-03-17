using System;
using System.Collections.Generic;
using System.IO.Ports;
using System.Text;
using System.Threading;

class SerialCommunicator
{
    private static SerialPort serialPort;

    static void Main(string[] args)
    {
        string portName = "COM9"; // Replace with your COM port
        int baudRate = 115200;
        int dataBits = 8;
        Parity parity = Parity.None;
        StopBits stopBits = StopBits.One;

        serialPort = new SerialPort(portName, baudRate, parity, dataBits, stopBits)
        {
            ReadTimeout = 10000,  // Timeout for reading (in milliseconds)
            WriteTimeout = 10000 // Timeout for writing (in milliseconds)
        };


        try
        {
            // Open the serial port
            serialPort.Open();
            Console.WriteLine($"Connected to {portName}");

            // Start reading data in a separate thread
            Thread readThread = new Thread(ReadData);
            readThread.Start();

            // Send data in the main thread
            while (true)
            {
                Console.WriteLine("Enter message to send: ");
                string message = Console.ReadLine();
                SendData(message);
            }
        }
        catch (Exception ex)
        {
            Console.WriteLine($"Error: {ex.Message}");
        }
        finally
        {
            // Ensure the port is closed when the application exits
            Console.WriteLine("Closing port...");
            serialPort.Close();
        }
    }

    // Method to send data
    static void SendData(string message)
    {
        try
        {
            if (serialPort.IsOpen)
            {
                serialPort.Write(message + "\n\r");
                Console.WriteLine($"Sent: {message}");
            }
            else
            {
                Console.WriteLine("Serial port is not open.");
            }
        }
        catch (Exception ex)
        {
            Console.WriteLine($"Send Error: {ex.Message}");
        }
    }

    // Method to read data from the serial port
    static void ReadData()
    {
        while (true)
        {
            try
            {
                if (serialPort.IsOpen)
                {
                    
                    string incomingData = serialPort.ReadLine();
                    incomingData = incomingData.Replace("\0", "").Replace("\r", "");
                    // Read data from the port
                    if (incomingData != string.Empty) {
                        Console.WriteLine($"Received: {incomingData}");
                    }
                    
                }
            }
            catch (TimeoutException)
            {
                // Ignore timeout exceptions as they're expected when there's no data
            }
            catch (Exception ex)
            {
                Console.WriteLine($"Read Error: {ex.Message}");
            }
        }
    }
}
