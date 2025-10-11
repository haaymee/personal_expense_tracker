import 'package:flutter/material.dart';

class HomeScreenHeaderDelegate extends SliverPersistentHeaderDelegate
{
  final Widget child;

  final double minExtents;
  final double maxExtents;
  

  HomeScreenHeaderDelegate({required this.child, this.minExtents = 60, this.maxExtents = 60});

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return child;
  }

  @override
  double get maxExtent => maxExtents;

  @override
  double get minExtent => minExtents;

  @override
  bool shouldRebuild(covariant HomeScreenHeaderDelegate oldDelegate) {
    return oldDelegate.child != child;
  }
  
}