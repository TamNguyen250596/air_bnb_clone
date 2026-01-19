import 'dart:io';
import 'package:air_bnb_clone/commons/widgets/custom_app_bar.dart';
import 'package:air_bnb_clone/data/models/place/place.dart';
import 'package:air_bnb_clone/modules/host/update_posting/update_posting_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../commons/widgets/facilities_widget.dart';
import '../../../routing/route_id.dart';

class UpdatePostingScreen extends StatefulWidget {
  // Init
  const UpdatePostingScreen({super.key, required this.viewModel});

  // Properties
  final UpdatePostingViewmodel viewModel;

  @override
  State<UpdatePostingScreen> createState() => _UpdatePostingScreenState();
}

class _UpdatePostingScreenState extends State<UpdatePostingScreen> {

  // ========== Properties ==========
  late final List<DropdownMenuItem<String>> _propertyTypes = widget
      .viewModel
      .propertyTypes
      .map((type) {
        return DropdownMenuItem(
          value: type,
          child: Text(
            type,
            style: const TextStyle(fontSize: 20, color: Colors.white),
          ),
        );
      })
      .toList();

  // Navigation
  Future<void> pushToSearchPropertyLocationScreen() async {
    final place = await context.pushNamed<Place>(
      RouteConstant.searchPropertyLocation,
    );
    widget.viewModel.updatePlace(place);
  }

  // ========== Build Method ==========
  List<Widget> _appBarActions() {
    if (widget.viewModel.isLoading) {
      return [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: SizedBox(
            width: 22,
            height: 22,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: Colors.white,
            ),
          ),
        ),
      ];
    } else {
      return [
        IconButton(
          icon: const Icon(Icons.upload_file_outlined, color: Colors.white),
          onPressed: () {},
        ),
      ];
    }
  }

  // ========== Form Field Widgets ==========
  Widget _postingNameField() {
    return TextFormField(
      decoration: const InputDecoration(labelText: "Posting Name"),
      style: const TextStyle(fontSize: 22.0, color: Colors.white),
      controller: widget.viewModel.nameController,
      validator: (text) {
        return widget.viewModel.validatePostingNameField(text);
      },
    );
  }

  Widget _propertyTypeDropdown() {
    return Padding(
      padding: const EdgeInsets.only(top: 30.0),
      child: InputDecorator(
        decoration: const InputDecoration(
          labelText: "Property Type",
          labelStyle: TextStyle(color: Colors.white70),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.grey),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
          ),
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            dropdownColor: Colors.grey[900],
            items: _propertyTypes,
            onChanged: (value) {
              widget.viewModel.updatePropertyTypeChosen(value);
            },
            isExpanded: true,
            value: widget.viewModel.propertyTypeChosen,
            hint: const Text(
              "Select property type",
              style: TextStyle(fontSize: 20, color: Colors.white70),
            ),
          ),
        ),
      ),
    );
  }

  Widget _priceField() {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          Expanded(
            child: TextFormField(
              decoration: const InputDecoration(labelText: "Price"),
              style: const TextStyle(fontSize: 22.0, color: Colors.white),
              keyboardType: TextInputType.number,
              controller: widget.viewModel.priceController,
              validator: (text) {
                return widget.viewModel.validatePriceNameField(text);
              },
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(left: 10.0, bottom: 10.0),
            child: Text(
              "💲 / night",
              style: TextStyle(fontSize: 18, color: Colors.white70),
            ),
          ),
        ],
      ),
    );
  }

  Widget _descriptionField() {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0),
      child: TextFormField(
        decoration: const InputDecoration(labelText: "Description"),
        style: const TextStyle(fontSize: 22.0, color: Colors.white),
        controller: widget.viewModel.descriptionController,
        maxLines: 3,
        minLines: 1,
        validator: (text) {
          return widget.viewModel.validateDescriptionField(text);
        },
      ),
    );
  }

  Widget _addressField(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0),
      child: GestureDetector(
        onTap: () async {
          await pushToSearchPropertyLocationScreen();
        },
        child: TextFormField(
          enabled: false,
          controller: widget.viewModel.addressController,
          maxLines: 3,
          style: const TextStyle(fontSize: 22.0, color: Colors.white70),
          decoration: const InputDecoration(
            labelText: "Address",
            labelStyle: TextStyle(color: Colors.white70),
            disabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.grey),
            ),
          ),
          validator: (text) {
            if (text!.isEmpty) {
              return "Please enter a valid address";
            }
            return null;
          },
        ),
      ),
    );
  }


  Widget _bedsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(top: 30.0),
          child: Text(
            'Beds',
            style: TextStyle(
              fontSize: 24.0,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        FacilitiesWidget(
          type: 'Twin/Single',
          startValue: widget.viewModel.geBedNo("small"),
          onValueChanged: (value) {
            widget.viewModel.updateBedNo("small", value);
          },
        ),
        FacilitiesWidget(
          type: 'Double',
          startValue: widget.viewModel.geBedNo("medium"),
          onValueChanged: (value) {
            widget.viewModel.updateBedNo("medium", value);
          },
        ),
        FacilitiesWidget(
          type: 'Queen/King',
          startValue: widget.viewModel.geBedNo("large"),
          onValueChanged: (value) {
            widget.viewModel.updateBedNo("large", value);
          }
        ),
      ],
    );
  }

  Widget _bedsSpacing() {
    return const SizedBox(height: 16);
  }

  Widget _bathroomsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(top: 20.0),
          child: Text(
            'Bathrooms',
            style: TextStyle(
              fontSize: 24.0,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        FacilitiesWidget(
          type: 'Full',
          startValue: widget.viewModel.geBathroomNo("full"),
          onValueChanged: (value) {
            widget.viewModel.updateBathroomNo("full", value);
          }
        ),
        FacilitiesWidget(
          type: 'Half',
          startValue: widget.viewModel.geBathroomNo("half"),
          onValueChanged: (value) {
            widget.viewModel.updateBathroomNo("half", value);
          }
        ),
      ],
    );
  }

  Widget _amenitiesField() {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0),
      child: TextFormField(
        decoration: const InputDecoration(
            labelText: "Amenities (comma separated)"),
        style: const TextStyle(
          fontSize: 22.0,
          color: Colors.white,
        ),
        controller: widget.viewModel.amenitiesController,
        validator: (text) {
          return widget.viewModel.validateAmenitiesField(text);
        },
        maxLines: 3,
        minLines: 1,
      ),
    );
  }

  Widget _photosSection() {
    final imageItems = widget.viewModel.imageItems;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(top: 20.0),
          child: Text(
            'Photos',
            style: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: imageItems.length,
          gridDelegate:
          const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 25,
            crossAxisSpacing: 25,
            childAspectRatio: 3 / 2,
          ),
          itemBuilder: (context, index) {
            final item = imageItems[index];
            if (item.id == "plus_item") {
              return Container(
                color: Colors.grey[900],
                child: IconButton(
                  icon: const Icon(Icons.add,
                      color: Colors.white),
                  onPressed: () {
                    widget.viewModel.selectImage(item);
                  },
                ),
              );
            } else {
              return MaterialButton(
                onPressed: () {},
                child: Image.file(
                  File(imageItems[index].imageUrl ?? ""),
                  fit: BoxFit.fill,
                )
              );
            }
          },
        ),
      ],
    );
  }

  Widget _form(BuildContext context) {
    return Form(
      key: widget.viewModel.formKey,
      child: Theme(
        data: ThemeData.dark().copyWith(
          inputDecorationTheme: const InputDecorationTheme(
            labelStyle: TextStyle(color: Colors.white),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.grey),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.white),
            ),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _postingNameField(),
            _propertyTypeDropdown(),
            _priceField(),
            _descriptionField(),
            _addressField(context),
            _bedsSection(),
            _bedsSpacing(),
            _bathroomsSection(),
            _amenitiesField(),
            _photosSection(),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: widget.viewModel,
      builder: (context, _) {
        return Scaffold(
          appBar: CustomAppBar(
            title: widget.viewModel.posting == null
                ? "Add New Posting"
                : "Update Posting",
            actions: _appBarActions(),
          ),
          body: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(25, 25, 25, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Post to Online Marketplace",
                    style: TextStyle(fontSize: 20, color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                  _form(context),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
