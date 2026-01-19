import 'package:flutter/material.dart';

class FacilitiesWidget extends StatefulWidget {

  // Init
  const FacilitiesWidget({
    super.key,
    required this.type,
    required this.startValue,
    required this.onValueChanged
  });

  // Properties
  final String type;
  final int startValue;
  final void Function(int) onValueChanged;

  @override
  State<FacilitiesWidget> createState() => _FacilitiesWidgetState();
}

class _FacilitiesWidgetState extends State<FacilitiesWidget> {

  // Properties
  int? _value;

  // Life cycle
  @override
  void initState() {
    super.initState();
    _value = widget.startValue;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[

          Text(
            widget.type,
            style: const TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.w500,
              color: Colors.white60,
            ),
          ),

          Row(
            children: <Widget>[
              IconButton(
                icon: const Icon(Icons.remove, color: Colors.white),
                onPressed: () {
                  _value = (_value! - 1).clamp(0, 9999);
                  widget.onValueChanged(_value!);
                  setState(() {});
                },
              ),
              Text(
                _value.toString(),
                style: const TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.add, color: Colors.white),
                onPressed: () {
                  _value = _value! + 1;
                  widget.onValueChanged(_value!);
                  setState(() {});
                },
              ),
            ],
          ),

        ],
      ),
    );
  }
}