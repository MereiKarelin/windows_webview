import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:screenshot/screenshot.dart';
import 'package:webview_windows/webview_windows.dart';

class WebviewPage extends StatefulWidget {
  @override
  _WebviewPageState createState() => _WebviewPageState();
}

class _WebviewPageState extends State<WebviewPage> {
  final WebviewController _controller = WebviewController();
  final ScreenshotController _screenshotController = ScreenshotController();
  Uint8List? _screenshotBytes;

  @override
  void initState() {
    super.initState();
    _initializeWebview();
  }

  Future<void> _initializeWebview() async {
    await _controller.initialize();
    await _controller.setBackgroundColor(Colors.transparent);
    await _controller.setPopupWindowPolicy(WebviewPopupWindowPolicy.deny);
    _controller.url.listen((url) {
      print('Webview is loading: $url');
    });

    // Load the HTML content
    String htmlContent = '''<html lang="en">

<head>
    <meta charset="UTF-8">

    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <title>Dynamic Table Example</title>
    
   <style>
    table {
        width: 100%;
        /* Set the table width to 100% */
    }

    #paymentsTable th,
    #paymentsTable td:first-child {
        text-align: center;
        font-size: 2em;
    }
    
    #paymentsTable td:nth-child(2) {
        font-size: 2em;
    }

    #paymentsTable td:nth-child(3) {
        text-align: right;
        font-size: 2em;
        /* Align the values in the third column (Price) to the right */
    }
    
    #tableInfo td:nth-child(1) {
        text-align: left;
        font-size: 2em;
    }

    #tableInfo td:nth-child(2) {
        text-align: right;
        font-size: 2em;
    }

    #version,
    #lastSync {
      text-align: center;
      font-size: 1.5em;
      font-weight: bold;
      margin-top: 5px;
      margin-bottom: 10px;
    }

    #paymentsTable ul {
        list-style-type: none;
        padding: 0;
        margin: 0;
    }

    #foo {
      min-height: auto;
    }

    h2 {
        text-align: center;
        /* Center-align the heading */
        font-size: 2.5em;
        /* Increase the font size */
        margin-bottom: 10px;
        /* Reduce the vertical margin after "Kitchen Receipt" */
    }

    #idout,
    #tableName,
    #subdivision,
    #note {
        text-align: center;
        font-size: 2em;
        /* Increase the font size */
        margin-top: 5px;
        /* Reduce the vertical margin after "Order #" */
        margin-bottom: 10px;
        /* Reduce the vertical margin after "Order #" */
    }

    .modifier-list {
        padding-left: 10px;
        /* Add padding only on the left of modifier names */
    }

    .parent {
      text-align: center;
    }

    .child {
      display: inline-block;
      vertical-align: middle;
    }

</style>
</head>

<body>
    <div id="foo">

        <div id="receipt-image">

            <h2 id="recieptTitle"></h2>

            <div id="subdivision"></div>

            <div class="parent">

            <div class="child" id="idout"></div>

            <div class="child" id="tableName"></div>

            </div>

            <div id="note"></div>
            
            <table id="tableInfo" border="0">
              <tbody>
                  <tr>
                      <td id="printedDateTitle"></td>
                      <td id="printedDate"></td>
                  </tr>
              </tbody>
           </table>
           
           <br>

           <table id="paymentsTable" border="1">

                <thead>

                    <tr>

                        <th>#</th>

                        <th id="nameTableRow"></th>
                        <th id="priceTableRow"></th>

                    </tr>

                </thead>

                <tbody></tbody>

           </table>
            
        </div>
        
        <br>

        <div id="version"></div>

        <div id="lastSync"></div>

        <script>
    // Array with data to insert into the table
    var prindata = [];

    if (prindata.length == 0) {
        prindata = [
            {
              "recieptTitle":"Kitchen receipt",
              "nameTableRow":"value",
              "priceTableRow":"price",
              "note":"dine in",
              "idout":"#9",
              "subdivision":"desert",
              "version":"0.1.5-DEBUG",
              "lastSync":"2024-04-24T09:39:42.085",
              "tableName":"table  8",
              "items":[
                  {
                    "#":"1",
                    "name":"1x pepsi ",
                    "modifiers":[],
                    "price":"900.0",
                    "printPriority":"FIRE"
                  }
                ]
            }
          ];
    }

    // Function to insert data into the table
    function populateTable(data) {
        var table = document.getElementById('paymentsTable').getElementsByTagName('tbody')[0];

        // Iterate over each object in the data array
        data.forEach(function(item) {
            // Create a new row and cells
            var newRow = table.insertRow(table.rows.length);

            // Create cells for each column
            var cell1 = newRow.insertCell(0);
            var cell2 = newRow.insertCell(1);
            var cell3 = newRow.insertCell(2);

            // Insert data into cells
            cell1.innerHTML = item["#"];
            cell2.innerHTML = '<strong>' + item.printPriority + '</strong> ' + item.name + renderModifiers(item.modifiers, 'name');
            cell3.innerHTML = item.price + renderModifiers(item.modifiers, 'price');
        });
    }

    // Function to render modifiers
    function renderModifiers(modifiers, field) {
        if (!modifiers || modifiers.length === 0) {
            return ''; // Return an empty string if no modifiers
        }

        var result = '<ul class="modifier-list">'; // Start an unordered list for modifiers with a class
        // Add padding only on the left of modifier names

        // Iterate over modifiers and add each modifier to the list
        modifiers.forEach(function(modifier) {
            result += '<li>' + '&nbsp;&nbsp;' + modifier[field] + '</li>'; // Add indentation using non-breaking spaces
        });

        result += '</ul>'; // Close the unordered list

        return result;
    }

    // Call the function to populate the table with data from prindata
    populateTable(prindata[0]['content'].items);

    /// LABELS

    // Set reciept title
    document.getElementById('recieptTitle').innerHTML = prindata[0]['labels'].recieptTitle;

    // Set table name row
    document.getElementById('nameTableRow').innerHTML = prindata[0]['labels'].nameTableRow;

    // Set table price row
    document.getElementById('priceTableRow').innerHTML = prindata[0]['labels'].priceTableRow;

    /// CONTENT

    // Set idout
    document.getElementById('idout').innerHTML = prindata[0]['content'].idout;
    
    // Set table name
    document.getElementById('tableName').innerHTML = prindata[0]['content'].tableName;
    
    // Set order type
    document.getElementById('note').innerHTML = prindata[0]['content'].note[0].toUpperCase() + prindata[0]['content'].note.substring(1);

    // Set version
    document.getElementById('version').innerHTML = 'PalomaPOS v' + prindata[0]['content'].version;

    // Set lastSync
    document.getElementById('lastSync').innerHTML = prindata[0]['content'].lastSync;

    // Set subdivision
    document.getElementById('subdivision').innerHTML = prindata[0]['content'].subdivision;
    
    document.getElementById('printedDateTitle').innerHTML = prindata[0]['labels'].printedDateTitle;
    document.getElementById('printedDate').innerHTML = prindata[0]['content'].printedDate +'&nbsp;'+ prindata[0]['content'].printedTime;



    function takeshot() {
        var div = document.getElementById('receipt-image');
        var canvas = document.createElement('canvas');
        html2canvas(div).then(function(canvas) {
            var a = document.createElement('a');
            a.href = canvas.toDataURL("image/png");
            a.download = 'image.png';
            a.click();
            a.remove();
        });

    }
</script>
        <script src="https://cdn.jsdelivr.net/npm/html2canvas@1.0.0-rc.5/dist/html2canvas.min.js" defer>
</script>
        <hr />
        <hr />
    </div>
</body>

</html>''';

    await _controller.loadUrl(Uri.dataFromString(htmlContent, mimeType: 'text/html').toString());
    setState(() {});
  }

  Future<void> _takeScreenshot() async {
    final screenshotBytes = await _screenshotController.capture();
    setState(() {
      _screenshotBytes = screenshotBytes;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('WebView Screenshot Example'),
      ),
      body: Column(
        children: [
          Expanded(
            child: Screenshot(
              controller: _screenshotController,
              child: _controller.value.isInitialized ? Webview(_controller) : Center(child: CircularProgressIndicator()),
            ),
          ),
          if (_screenshotBytes != null)
            Expanded(
              child: Image.memory(_screenshotBytes!),
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _takeScreenshot,
        child: Icon(Icons.camera_alt),
      ),
    );
  }
}
