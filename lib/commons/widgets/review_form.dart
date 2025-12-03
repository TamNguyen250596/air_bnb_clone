import 'package:air_bnb_clone/commons/widgets/rating_bar.dart';
import 'package:flutter/material.dart';

class ReviewForm extends StatefulWidget {

  const ReviewForm({
    super.key,
    required this.onRatingChanged,
    this.initialRating = 0.0,
  });

  /// Called when the user changes the rating.
  final ValueChanged<double> onRatingChanged;

  final double initialRating;

  @override
  State<ReviewForm> createState() => _ReviewFormState();
}

class _ReviewFormState extends State<ReviewForm> {
  // Properties
  final TextEditingController _controller = TextEditingController();

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
                    style: const TextStyle(
                      fontSize: 16,
                    ),
                    controller: _controller,
                    validator: (text){
                      if(text!.isEmpty){
                        return "Please enter some text";
                      }
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
                          initialRating: widget.initialRating,
                          filledIcon: Icons.star,
                          emptyIcon: Icons.star_border,
                          filledColor: Colors.green,
                          onRatingChanged: widget.onRatingChanged,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: MaterialButton(
                          onPressed: () {},
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
