import 'package:air_bnb_clone/commons/widgets/rating_bar.dart';
import 'package:flutter/material.dart';

class ReviewForm extends StatefulWidget {

  const ReviewForm({
    super.key,
    required this.onRatingChanged,
    this.initialRating = 0.0,
    this.onSubmitted,
  });

  /// Called when the user changes the rating.
  final ValueChanged<double> onRatingChanged;
  final double initialRating;
  final ValueChanged<String>? onSubmitted;

  @override
  State<ReviewForm> createState() => _ReviewFormState();
}

class _ReviewFormState extends State<ReviewForm> {

  // Properties
  double _rating = 0.0;
  final TextEditingController _controller = TextEditingController();

  // Life cycle
  @override
  void initState() {
    super.initState();
    _rating = widget.initialRating;
  }

  // Content
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.black,
          width: 2.0,
        ),
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Form(
              child: Column(
                children: <Widget>[
                  TextFormField(
                    decoration: const InputDecoration(
                      hintText: 'write here...',
                    ),
                    maxLines: 1,
                    controller: _controller,
                    style: const TextStyle(
                      fontSize: 16,
                    ),
                    validator: (text) {
                      if (text!.isEmpty) {
                        return "Please enter some text";
                      }
                      return null;
                    },
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 20.0, bottom: 10.0),
                        child: RatingBar(
                          size: 40.0,
                          maxRating: 5,
                          initialRating: _rating,
                          filledIcon: Icons.star,
                          emptyIcon: Icons.star_border,
                          filledColor: Colors.green,
                          onRatingChanged: (value) => {
                            setState(() {
                              _rating = value;
                            }),
                            widget.onRatingChanged(value),
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: MaterialButton(
                          onPressed: () {
                            if (_controller.text.isNotEmpty) {
                              widget.onSubmitted!(_controller.text);
                              _controller.clear();
                              setState(() {
                                _rating = 0.0;
                              });
                            }
                          },
                          color: Colors.black,
                          child: const Text(
                            'Submit',
                            style: TextStyle(
                                color: Colors.white
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
