import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        Card(
          child: ListTile(
            leading: SizedBox(
              width: 30,
              height: 30,
              child: SvgPicture.asset(
                'icons/insta.svg',
                fit: BoxFit.contain,
                colorFilter: ColorFilter.mode(
                  Theme.of(context).colorScheme.onSurfaceVariant,
                  BlendMode.srcIn,
                ),
              ),
            ),
            title: Text('Unfollower Hunter'),
            subtitle: Text('Upload instagram data file and find unfollowers'),
            onTap: () => Navigator.pushNamed(context, '/unfollower-hunter'),
          ),
        ),
      ],
    );
  }
}
