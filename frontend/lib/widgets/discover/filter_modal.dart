import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../constants/app_colors.dart';
import '../../providers/discover_provider.dart';

class FilterModal extends StatefulWidget {
  const FilterModal({Key? key}) : super(key: key);

  @override
  State<FilterModal> createState() => _FilterModalState();
}

class _FilterModalState extends State<FilterModal> {
  String _selectedFilterType = 'people';
  final TextEditingController _skillsController = TextEditingController();
  final TextEditingController _domainController = TextEditingController();
  String _selectedLocation = '';
  int _availabilityHours = 10;

  final List<Map<String, String>> _filterTypes = [
    {'id': 'people', 'label': 'People'},
    {'id': 'mentors', 'label': 'Mentors'},
    {'id': 'topics', 'label': 'Topics'},
    {'id': 'tribes', 'label': 'Tribes'},
  ];

  final List<String> _locations = [
    'New York, NY',
    'San Francisco, CA',
    'Los Angeles, CA',
    'Chicago, IL',
    'Austin, TX',
    'Seattle, WA',
    'Miami, FL',
    'Boston, MA',
    'Denver, CO',
    'Portland, OR',
  ];

  @override
  void initState() {
    super.initState();
    final provider = Provider.of<DiscoverProvider>(context, listen: false);
    _selectedFilterType = provider.currentFilter.filterType;
    _selectedLocation = provider.currentFilter.location;
    _availabilityHours = provider.currentFilter.availabilityHours;
    _skillsController.text = provider.currentFilter.skills.join(', ');
    _domainController.text = provider.currentFilter.projectDomain;
  }

  @override
  void dispose() {
    _skillsController.dispose();
    _domainController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      decoration: const BoxDecoration(
        color: AppColors.backgroundColor,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                // Drag Handle
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.textSecondaryColor.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 20),
                // Title and Close
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Filters',
                      style: TextStyle(
                        color: AppColors.textColor,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.close,
                        color: AppColors.textColor,
                      ),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                // Subtitle
                const Text(
                  'Apply search and suggestion filters to find what you need',
                  style: TextStyle(
                    color: AppColors.textSecondaryColor,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          const Divider(
            color: AppColors.textFieldColor,
            height: 1,
          ),
          // Content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Filter Type Tabs
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: _filterTypes.map((type) {
                        final isSelected = _selectedFilterType == type['id'];
                        return Padding(
                          padding: const EdgeInsets.only(right: 12),
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                _selectedFilterType = type['id']!;
                              });
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 10,
                              ),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? AppColors.buttonColor
                                    : AppColors.textFieldColor,
                                borderRadius: BorderRadius.circular(24),
                              ),
                              child: Text(
                                type['label']!,
                                style: TextStyle(
                                  color: isSelected
                                      ? AppColors.buttonTextColor
                                      : AppColors.textSecondaryColor,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Skills Field
                  const Text(
                    'Skills',
                    style: TextStyle(
                      color: AppColors.textColor,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.textFieldColor,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: TextField(
                      controller: _skillsController,
                      style: const TextStyle(
                        color: AppColors.textColor,
                        fontSize: 14,
                      ),
                      decoration: const InputDecoration(
                        hintText: 'what skills would you like that person to have?',
                        hintStyle: TextStyle(
                          color: AppColors.textSecondaryColor,
                          fontSize: 14,
                        ),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.all(16),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Location Field
                  const Text(
                    'Location',
                    style: TextStyle(
                      color: AppColors.textColor,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.textFieldColor,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: DropdownButtonFormField<String>(
                      value: _selectedLocation.isEmpty ? null : _selectedLocation,
                      dropdownColor: AppColors.cardColor,
                      style: const TextStyle(
                        color: AppColors.textColor,
                        fontSize: 14,
                      ),
                      decoration: const InputDecoration(
                        hintText: 'Choose a location',
                        hintStyle: TextStyle(
                          color: AppColors.textSecondaryColor,
                          fontSize: 14,
                        ),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        suffixIcon: Icon(
                          Icons.keyboard_arrow_down,
                          color: AppColors.textSecondaryColor,
                        ),
                      ),
                      items: _locations.map((location) {
                        return DropdownMenuItem(
                          value: location,
                          child: Text(location),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedLocation = value ?? '';
                        });
                      },
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Project Domain Field
                  const Text(
                    'Project Domain/Interest Area',
                    style: TextStyle(
                      color: AppColors.textColor,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.textFieldColor,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: TextField(
                      controller: _domainController,
                      style: const TextStyle(
                        color: AppColors.textColor,
                        fontSize: 14,
                      ),
                      decoration: const InputDecoration(
                        hintText: 'what domains/interests would you like them to have?',
                        hintStyle: TextStyle(
                          color: AppColors.textSecondaryColor,
                          fontSize: 14,
                        ),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.all(16),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Availability Slider
                  const Text(
                    'Availability (hours per week)',
                    style: TextStyle(
                      color: AppColors.textColor,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      // Minus Button
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: AppColors.textFieldColor,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: IconButton(
                          icon: const Icon(
                            Icons.remove,
                            color: AppColors.textColor,
                            size: 20,
                          ),
                          onPressed: () {
                            if (_availabilityHours > 0) {
                              setState(() {
                                _availabilityHours--;
                              });
                            }
                          },
                        ),
                      ),
                      const SizedBox(width: 16),
                      // Hours Display
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.textFieldColor,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          '$_availabilityHours',
                          style: const TextStyle(
                            color: AppColors.textColor,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      // Plus Button
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: AppColors.primaryPurple,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: IconButton(
                          icon: const Icon(
                            Icons.add,
                            color: AppColors.textColor,
                            size: 20,
                          ),
                          onPressed: () {
                            if (_availabilityHours < 100) {
                              setState(() {
                                _availabilityHours++;
                              });
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
          // Bottom Buttons
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.backgroundColor,
              border: Border(
                top: BorderSide(
                  color: AppColors.textFieldColor,
                  width: 1,
                ),
              ),
            ),
            child: Row(
              children: [
                // Reset Button
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      setState(() {
                        _selectedFilterType = 'people';
                        _skillsController.clear();
                        _domainController.clear();
                        _selectedLocation = '';
                        _availabilityHours = 10;
                      });
                      Provider.of<DiscoverProvider>(context, listen: false)
                          .resetFilters();
                    },
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(
                        color: AppColors.textSecondaryColor,
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Reset',
                      style: TextStyle(
                        color: AppColors.textColor,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                // Select All Button
                Expanded(
                  flex: 2,
                  child: ElevatedButton(
                    onPressed: () {
                      final skills = _skillsController.text
                          .split(',')
                          .map((s) => s.trim())
                          .where((s) => s.isNotEmpty)
                          .toList();

                      Provider.of<DiscoverProvider>(context, listen: false)
                          .applyFilters(
                        filterType: _selectedFilterType,
                        skills: skills,
                        location: _selectedLocation,
                        projectDomain: _domainController.text,
                        availabilityHours: _availabilityHours,
                      );

                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFBBAECC),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    child: const Text(
                      'Select All',
                      style: TextStyle(
                        color: AppColors.backgroundColor,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}



