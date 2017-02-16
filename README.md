# Project 3 - Yelp

Time spent: 9.5 hours spent in total

## User Stories

The following **required** functionality is completed:

- [X] Table rows for search results should be dynamic height according to the content height.
- [X] Custom cells should have the proper Auto Layout constraints.
- [X] Search bar should be in the navigation bar (doesn't have to expand to show location like the real Yelp app does).

The following **optional** features are implemented:

- [X] Search results page
   - [X] Infinite scroll for restaurant results.
   - [X] Implement map view of restaurant results.
- [X] Implement the restaurant detail page.

The following **additional** features are implemented:

- [X] App icon and splash screen
- [X] Map view in the detail page
- [X] Yelp's Business API (besides the Search API), which is used to pull review
- [X] Navigation from map view to detail view
- [X] Filter search result (by category) - multi-selection supported
- [X] Landscape mode added
- [X] Location service supported
- [X] Loading indicator added

Please list two areas of the assignment you'd like to **discuss further with your peers** during the next class (examples include better ways to implement something, how to extend your app in certain ways, etc):

1. In terms of adding custom view to the navigation bar, which way is better: creating view via an xib file or programmatically?
2. What are some MapKit callback methods that we should know/master?

## Video Walkthrough 

Here's a walkthrough of implemented user stories:

<img src='http://i.imgur.com/X5bKf7I.gif' title='Video Walkthrough' width='' alt='Video Walkthrough' />

GIF created with [LiceCap](http://www.cockos.com/licecap/).

## Notes

The business image view in detail page took me a while because the image kept getting out of bound although I did set up proper constraints. However, after trial and error, I found out that AFNetworking doesn't work well with content size being Aspect Fill (Content Fill and Aspect Fit work perfectly though).

## License

    Copyright [2017] [Thomas Zhu]

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
