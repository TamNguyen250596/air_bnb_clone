import 'dart:io';
import 'package:air_bnb_clone/commons/widgets/custom_app_bar.dart';
import 'package:air_bnb_clone/data/models/place/place.dart';
import 'package:air_bnb_clone/modules/host/update_posting/update_posting_viewmodel.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../commons/widgets/facilities_widget.dart';
import '../../../routing/route_id.dart';

class UpdatePostingScreen extends StatefulWidget {
  // Init
  const UpdatePostingScreen({super.key});

  // Properties

  @override
  State<UpdatePostingScreen> createState() => _UpdatePostingScreenState();
}

class _UpdatePostingScreenState extends State<UpdatePostingScreen> {

  // Form Key
  final _formKey = GlobalKey<FormState>();

  // TextEditingControllers
  final TextEditingController _addressController = TextEditingController();

  // Navigation
  Future<void> pushToSearchPropertyLocationScreen() async {
    final vm = context.read<UpdatePostingViewModel>();
    final place = await context.pushNamed<Place>(
      RouteConstant.searchPropertyLocation,
    );
    vm.updatePlace(place);
    if (place != null) {
      setState(() {
        _addressController.text = vm.address;
      });
    }
  }

  void popBack() {
    context.pop();
  }

  // Life cycle
  @override
  void initState() {
    super.initState();
    final vm = context.read<UpdatePostingViewModel>();
    _addressController.value = TextEditingValue(text: vm.address);
  }

  // ========== Build Method ==========
  List<Widget> _appBarActions(UpdatePostingViewModel viewModel) {
    if (viewModel.isLoading) {
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
          onPressed: () async {
            final isSuccess = await viewModel.createPosting(_formKey);
            if (isSuccess) {
              popBack();
            }
          },
        ),
      ];
    }
  }

  // ========== Form Field Widgets ==========
  Widget _postingNameField() {
    return Consumer<UpdatePostingViewModel>(
      builder: (context, viewModel, child) {
        return TextFormField(
          decoration: const InputDecoration(labelText: "Posting Name"),
          style: const TextStyle(fontSize: 22.0, color: Colors.white),
          initialValue: viewModel.name,
          onChanged: (text) {
            viewModel.updateName(text);
          },
          validator: (text) {
            return viewModel.validatePostingNameField(text);
          },
        );
      },
    );
  }

  Widget _propertyTypeDropdown() {
    return Consumer<UpdatePostingViewModel>(
      builder: (context, viewModel, child) {
        final propertyTypes = viewModel.propertyTypes.map((type) {
          return DropdownMenuItem(
            value: type,
            child: Text(
              type,
              style: const TextStyle(fontSize: 20, color: Colors.white),
            ),
          );
        }).toList();

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
                items: propertyTypes,
                onChanged: (value) {
                  viewModel.updatePropertyTypeChosen(value);
                },
                isExpanded: true,
                value: viewModel.propertyTypeChosen,
                hint: const Text(
                  "Select property type",
                  style: TextStyle(fontSize: 20, color: Colors.white70),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _priceField() {
    return Consumer<UpdatePostingViewModel>(
      builder: (context, viewModel, child) {
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
                  initialValue: viewModel.price,
                  onChanged: (text) {
                    viewModel.updatePrice(text);
                  },
                  validator: (text) {
                    return viewModel.validatePriceNameField(text);
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
      },
    );
  }

  Widget _descriptionField() {
    return Consumer<UpdatePostingViewModel>(
      builder: (context, viewModel, child) {
        return Padding(
          padding: const EdgeInsets.only(top: 20.0),
          child: TextFormField(
            decoration: const InputDecoration(labelText: "Description"),
            style: const TextStyle(fontSize: 22.0, color: Colors.white),
            initialValue: viewModel.description,
            onChanged: (text) {
              viewModel.updateDescription(text);
            },
            maxLines: 3,
            minLines: 1,
            validator: (text) {
              return viewModel.validateDescriptionField(text);
            },
          ),
        );
      },
    );
  }

  Widget _addressField() {
    return Consumer<UpdatePostingViewModel>(
      builder: (context, viewModel, child) {
        return Padding(
          padding: const EdgeInsets.only(top: 20.0),
          child: GestureDetector(
            onTap: () async {
              await pushToSearchPropertyLocationScreen();
            },
            child: TextFormField(
              enabled: false,
              controller: _addressController,
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
      },
    );
  }


  Widget _bedsSection() {
    return Consumer<UpdatePostingViewModel>(
      builder: (context, viewModel, child) {
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
              startValue: viewModel.geBedNo("small"),
              onValueChanged: (value) {
                viewModel.updateBedNo("small", value);
              },
            ),
            FacilitiesWidget(
              type: 'Double',
              startValue: viewModel.geBedNo("medium"),
              onValueChanged: (value) {
                viewModel.updateBedNo("medium", value);
              },
            ),
            FacilitiesWidget(
              type: 'Queen/King',
              startValue: viewModel.geBedNo("large"),
              onValueChanged: (value) {
                viewModel.updateBedNo("large", value);
              }
            ),
          ],
        );
      },
    );
  }

  Widget _bedsSpacing() {
    return const SizedBox(height: 16);
  }

  Widget _bathroomsSection() {
    return Consumer<UpdatePostingViewModel>(
      builder: (context, viewModel, child) {
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
              startValue: viewModel.geBathroomNo("full"),
              onValueChanged: (value) {
                viewModel.updateBathroomNo("full", value);
              }
            ),
            FacilitiesWidget(
              type: 'Half',
              startValue: viewModel.geBathroomNo("half"),
              onValueChanged: (value) {
                viewModel.updateBathroomNo("half", value);
              }
            ),
          ],
        );
      },
    );
  }

  Widget _amenitiesField() {
    return Consumer<UpdatePostingViewModel>(
      builder: (context, viewModel, child) {
        return Padding(
          padding: const EdgeInsets.only(top: 20.0),
          child: TextFormField(
            decoration: const InputDecoration(
                labelText: "Amenities (comma separated)"),
            style: const TextStyle(
              fontSize: 22.0,
              color: Colors.white,
            ),
            initialValue: viewModel.amenities,
            onChanged: (text) {
              viewModel.updateAmenities(text);
            },
            validator: (text) {
              return viewModel.validateAmenitiesField(text);
            },
            maxLines: 3,
            minLines: 1,
          ),
        );
      },
    );
  }

  Widget _photosSection() {
    return Consumer<UpdatePostingViewModel>(
      builder: (context, viewModel, child) {
        final imageItems = viewModel.imageItems;

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
                switch (item.tag) {
                  case "plus_item":
                    return Container(
                      color: Colors.grey[900],
                      child: IconButton(
                        icon: const Icon(Icons.add, color: Colors.white),
                        onPressed: () {
                          viewModel.selectImage(item);
                        },
                      ),
                    );
                  case "remote_image":
                    return MaterialButton(
                      onPressed: () {
                        viewModel.selectImage(item);
                      },
                      child: CachedNetworkImage(
                        imageUrl: item.imageUrl,
                        fit: BoxFit.fill,
                      ),
                    );
                  case "local_image":
                    return MaterialButton(
                      onPressed: () {
                        viewModel.selectImage(item);
                      },
                      child: Image.file(
                        File(item.imageUrl),
                        fit: BoxFit.fill,
                      ),
                    );
                  default:
                    return const SizedBox.shrink();
                }
              },
            ),
          ],
        );
      },
    );
  }

  Widget _form(BuildContext context) {
    return Form(
      key: _formKey,
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
            _addressField(),
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
    return Consumer<UpdatePostingViewModel>(
      builder: (context, viewModel, child) {
        return Scaffold(
          appBar: CustomAppBar(
            title: viewModel.posting == null
                ? "Add New Posting"
                : "Update Posting",
            actions: _appBarActions(viewModel),
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
