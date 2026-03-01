import 'dart:io';
import 'package:air_bnb_clone/commons/widgets/custom_app_bar.dart';
import 'package:air_bnb_clone/data/models/place/place.dart';
import 'package:air_bnb_clone/modules/host/update_posting/update_posting_cubit.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../commons/widgets/facilities_widget.dart';
import '../../../routing/route_id.dart';

class UpdatePostingScreen extends StatefulWidget {
  const UpdatePostingScreen({super.key});

  @override
  State<UpdatePostingScreen> createState() => _UpdatePostingScreenState();
}

class _UpdatePostingScreenState extends State<UpdatePostingScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _addressController = TextEditingController();

  Future<void> _pushToSearchPropertyLocationScreen() async {
    final place = await context.pushNamed<Place>(
      RouteConstant.searchPropertyLocation,
    );
    if (!mounted) return;
    if (place != null) {
      context.read<UpdatePostingCubit>().updatePlace(place);
      final state = context.read<UpdatePostingCubit>().state;
      setState(() {
        _addressController.text = state.address;
      });
    }
  }

  void _popBack() {
    context.pop();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        final state = context.read<UpdatePostingCubit>().state;
        _addressController.text = state.address;
      }
    });
  }

  List<Widget> _appBarActions(UpdatePostingState state, UpdatePostingCubit cubit) {
    if (state.isLoading) {
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
    }
    return [
      IconButton(
        icon: const Icon(Icons.upload_file_outlined, color: Colors.white),
        onPressed: () async {
          final isSuccess = await cubit.createPosting(_formKey);
          if (isSuccess && mounted) _popBack();
        },
      ),
    ];
  }

  Widget _postingNameField() {
    return BlocBuilder<UpdatePostingCubit, UpdatePostingState>(
      builder: (context, state) {
        final cubit = context.read<UpdatePostingCubit>();
        return TextFormField(
          decoration: const InputDecoration(labelText: "Posting Name"),
          style: const TextStyle(fontSize: 22.0, color: Colors.white),
          initialValue: state.name,
          onChanged: cubit.updateName,
          validator: cubit.validatePostingNameField,
        );
      },
    );
  }

  Widget _propertyTypeDropdown() {
    return BlocBuilder<UpdatePostingCubit, UpdatePostingState>(
      builder: (context, state) {
        final cubit = context.read<UpdatePostingCubit>();
        final propertyTypes = state.propertyTypes.map((type) {
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
                onChanged: cubit.updatePropertyTypeChosen,
                isExpanded: true,
                value: state.propertyTypeChosen,
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
    return BlocBuilder<UpdatePostingCubit, UpdatePostingState>(
      builder: (context, state) {
        final cubit = context.read<UpdatePostingCubit>();
        return Padding(
          padding: const EdgeInsets.only(top: 20.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: TextFormField(
                  decoration: const InputDecoration(labelText: "Price"),
                  style: const TextStyle(fontSize: 22.0, color: Colors.white),
                  keyboardType: TextInputType.number,
                  initialValue: state.price,
                  onChanged: cubit.updatePrice,
                  validator: cubit.validatePriceNameField,
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
    return BlocBuilder<UpdatePostingCubit, UpdatePostingState>(
      builder: (context, state) {
        final cubit = context.read<UpdatePostingCubit>();
        return Padding(
          padding: const EdgeInsets.only(top: 20.0),
          child: TextFormField(
            decoration: const InputDecoration(labelText: "Description"),
            style: const TextStyle(fontSize: 22.0, color: Colors.white),
            initialValue: state.description,
            onChanged: cubit.updateDescription,
            maxLines: 3,
            minLines: 1,
            validator: cubit.validateDescriptionField,
          ),
        );
      },
    );
  }

  Widget _addressField() {
    return BlocBuilder<UpdatePostingCubit, UpdatePostingState>(
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.only(top: 20.0),
          child: GestureDetector(
            onTap: _pushToSearchPropertyLocationScreen,
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
                if (text == null || text.isEmpty) {
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
    return BlocBuilder<UpdatePostingCubit, UpdatePostingState>(
      builder: (context, state) {
        final cubit = context.read<UpdatePostingCubit>();
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
              startValue: cubit.getBedNo("small"),
              onValueChanged: (value) => cubit.updateBedNo("small", value),
            ),
            FacilitiesWidget(
              type: 'Double',
              startValue: cubit.getBedNo("medium"),
              onValueChanged: (value) => cubit.updateBedNo("medium", value),
            ),
            FacilitiesWidget(
              type: 'Queen/King',
              startValue: cubit.getBedNo("large"),
              onValueChanged: (value) => cubit.updateBedNo("large", value),
            ),
          ],
        );
      },
    );
  }

  Widget _bathroomsSection() {
    return BlocBuilder<UpdatePostingCubit, UpdatePostingState>(
      builder: (context, state) {
        final cubit = context.read<UpdatePostingCubit>();
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
              startValue: cubit.getBathroomNo("full"),
              onValueChanged: (value) => cubit.updateBathroomNo("full", value),
            ),
            FacilitiesWidget(
              type: 'Half',
              startValue: cubit.getBathroomNo("half"),
              onValueChanged: (value) => cubit.updateBathroomNo("half", value),
            ),
          ],
        );
      },
    );
  }

  Widget _amenitiesField() {
    return BlocBuilder<UpdatePostingCubit, UpdatePostingState>(
      builder: (context, state) {
        final cubit = context.read<UpdatePostingCubit>();
        return Padding(
          padding: const EdgeInsets.only(top: 20.0),
          child: TextFormField(
            decoration: const InputDecoration(
              labelText: "Amenities (comma separated)",
            ),
            style: const TextStyle(fontSize: 22.0, color: Colors.white),
            initialValue: state.amenities,
            onChanged: cubit.updateAmenities,
            validator: cubit.validateAmenitiesField,
            maxLines: 3,
            minLines: 1,
          ),
        );
      },
    );
  }

  Widget _photosSection() {
    return BlocBuilder<UpdatePostingCubit, UpdatePostingState>(
      builder: (context, state) {
        final cubit = context.read<UpdatePostingCubit>();
        final imageItems = state.imageItems;

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
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
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
                        onPressed: () => cubit.selectImage(item),
                      ),
                    );
                  case "remote_image":
                    return MaterialButton(
                      onPressed: () => cubit.selectImage(item),
                      child: CachedNetworkImage(
                        imageUrl: item.imageUrl,
                        fit: BoxFit.fill,
                      ),
                    );
                  case "local_image":
                    return MaterialButton(
                      onPressed: () => cubit.selectImage(item),
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
            const SizedBox(height: 16),
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
    return BlocBuilder<UpdatePostingCubit, UpdatePostingState>(
      builder: (context, state) {
        return Scaffold(
          appBar: CustomAppBar(
            title: state.posting == null ? "Add New Posting" : "Update Posting",
            actions: _appBarActions(state, context.read<UpdatePostingCubit>()),
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
