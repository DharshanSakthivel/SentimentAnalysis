import 'package:flutter/material.dart';
import 'api_service.dart';

void main() {
  runApp(SentimentApp());
}

class SentimentApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tweet Sentiment Analyzer',
      theme: ThemeData(primarySwatch: Colors.indigo),
      home: SentimentHomePage(),
    );
  }
}

class SentimentHomePage extends StatefulWidget {
  @override
  _SentimentHomePageState createState() => _SentimentHomePageState();
}

class _SentimentHomePageState extends State<SentimentHomePage> {
  final _controller = TextEditingController();
  String _selectedModel = 'lr_count';
  String _result = '';

  Future<void> _analyzeSentiment() async {
    final sentiment = await ApiService.predictSentiment(
      _controller.text,
      _selectedModel,
    );
    setState(() {
      _result = sentiment;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Sentiment Analyzer')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              keyboardType: TextInputType.multiline,
              textInputAction: TextInputAction.newline,
              decoration: InputDecoration(
                labelText: 'Enter tweet text',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _selectedModel,
              onChanged: (val) => setState(() => _selectedModel = val!),
              items: [
                DropdownMenuItem(value: 'lr_count', child: Text('Logistic Regression')),
                DropdownMenuItem(value: 'svm_count', child: Text('SVM')),
                DropdownMenuItem(value: 'nb_count', child: Text('Naive Bayes')),
                DropdownMenuItem(value: 'distilbert', child: Text('DistilBERT')),
                DropdownMenuItem(value: 'bert-base', child: Text('BERT Base')),
                DropdownMenuItem(value: 'bert-large', child: Text('BERT Large')),
                DropdownMenuItem(value: 'roberta', child: Text('RoBERTa')),
              ],
              decoration: InputDecoration(
                labelText: 'Choose model',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _analyzeSentiment,
              child: Text('Analyze'),
            ),
            SizedBox(height: 20),
            Text('Prediction: $_result', style: TextStyle(fontSize: 18)),
          ],
        ),
      ),
    );
  }
}
