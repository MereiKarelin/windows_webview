import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:screenshot/screenshot.dart';
import 'package:webview_windows/webview_windows.dart';
import 'package:windows_webview/webview.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Uint8List? _screenshot;

  @override
  void initState() {
    super.initState();
  }

  Future<void> showModal(BuildContext context) async {
    await Future.delayed(Duration(seconds: 4));
    showModalBottomSheet(
        context: context,
        builder: (context) => WebViewScreenshotWidget(
              htmlContent: '''
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dynamic Table Example</title>
    <style>
        table {
            width: 100%;
        }
        #paymentsTable th, #paymentsTable td:first-child {
            text-align: center;
            font-size: 2em;
        }
        #paymentsTable td:nth-child(2) {
            font-size: 2em;
        }
        #paymentsTable td:nth-child(3) {
            text-align: right;
            font-size: 2em;
        }
        #tableInfo td:nth-child(1) {
            text-align: left;
            font-size: 2em;
        }
        #tableInfo td:nth-child(2) {
            text-align: right;
            font-size: 2em;
        }
        #version, #lastSync {
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
            font-size: 2.5em;
            margin-bottom: 10px;
        }
        #idout, #tableName, #subdivision, #note {
            text-align: center;
            font-size: 2em;
            margin-top: 5px;
            margin-bottom: 10px;
        }
        .modifier-list {
            padding-left: 10px;
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
            function populateTable(data) {
                var table = document.getElementById('paymentsTable').getElementsByTagName('tbody')[0];
                data.forEach(function(item) {
                    var newRow = table.insertRow(table.rows.length);
                    var cell1 = newRow.insertCell(0);
                    var cell2 = newRow.insertCell(1);
                    var cell3 = newRow.insertCell(2);
                    cell1.innerHTML = item["#"];
                    cell2.innerHTML = '<strong>' + item.printPriority + '</strong> ' + item.name + renderModifiers(item.modifiers, 'name');
                    cell3.innerHTML = item.price + renderModifiers(item.modifiers, 'price');
                });
            }
            function renderModifiers(modifiers, field) {
                if (!modifiers || modifiers.length === 0) {
                    return '';
                }
                var result = '<ul class="modifier-list">';
                modifiers.forEach(function(modifier) {
                    result += '<li>' + '&nbsp;&nbsp;' + modifier[field] + '</li>';
                });
                result += '</ul>';
                return result;
            }
            populateTable(prindata[0]['items']);
            document.getElementById('recieptTitle').innerHTML = prindata[0]['recieptTitle'];
            document.getElementById('nameTableRow').innerHTML = prindata[0]['nameTableRow'];
            document.getElementById('priceTableRow').innerHTML = prindata[0]['priceTableRow'];
            document.getElementById('idout').innerHTML = prindata[0]['idout'];
            document.getElementById('tableName').innerHTML = prindata[0]['tableName'];
            document.getElementById('note').innerHTML = prindata[0]['note'][0].toUpperCase() + prindata[0]['note'].substring(1);
            document.getElementById('version').innerHTML = 'PalomaPOS v' + prindata[0]['version'];
            document.getElementById('lastSync').innerHTML = prindata[0]['lastSync'];
            document.getElementById('subdivision').innerHTML = prindata[0]['subdivision'];
            document.getElementById('printedDateTitle').innerHTML = prindata[0]['printedDateTitle'];
            document.getElementById('printedDate').innerHTML = prindata[0]['printedDate'] + '&nbsp;' + prindata[0]['printedTime'];
        </script>
        <script src="https://cdn.jsdelivr.net/npm/html2canvas@1.0.0-rc.5/dist/html2canvas.min.js" defer></script>
        <hr />
        <hr />
    </div>
</body>
</html>
    ''',
            ));
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('HTML to Screenshot Example'),
        ),
        body: Column(
          children: [
            // WebViewScreenshotWidget(
            //   htmlContent: ,
            // )
          ],
        ),
      ),
    );
  }
}
