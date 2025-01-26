# subrenamer
Bash and perl rename based file renamer for subtitles and other files where
you want to match the format of another group of files
with a fixed numbering scheme

## Dependency
GNU grep

[prename](https://github.com/pstray/rename) (In some distos this is called `rename`, but in Fedora `rename` is the util-linux rename. You can do `alias prename=rename`)

## Usage

```
rename.sh \
  -e subtitle episode regex [(?<=\[)\d\d(?=\])] \
  -x sub extension regex [\..*] \
  -t video episode regex [(?<=\[)\d\d(?=\])] \
  -f video extension [mkv] \
  -s subtitle extension [ass] \
  -p padding renamed number to length of N with zeros [] \
  -v verbose \
  -n dry run
```

### Example
If one has the some files like where the each mp4 file contains a HASH
```
.
├── Title Part 1 #01 Title Part 2 [25F9E8E6].mp4
├── Title Part 1 #02 Title Part 2 [63710608].mp4
├── Title Part 1 #03 Title Part 2 [FFB297D4].mp4
├── subname part 1 01 subname part 2.sc.ass
├── subname part 1 01 subname part 2.tc.ass
├── subname part 1 02 subname part 2.sc.ass
├── subname part 1 02 subname part 2.tc.ass
├── subname part 1 03 subname part 2.sc.ass
├── subname part 1 03 subname part 2.tc.ass
```
then you can use
`rename.sh -e '(?<= )\d\d(?= )' -t '(?<=#)\d\d)' -f mp4'`
which will create a folder under the current working directory named `done` and contains the renamed subtitles hardlinked to the original subtitles

> [!TIP]
> Use `-nv` to test run the rename

> [!NOTE]
> It's rarely needed to use the `-x` option unless the file names part contains dots that aren't part of the extension

> [!NOTE]
> For the most common type of files, where videos are mkv, subtitles are ass, and all episode names are two digit numbers
> surronded by \[\], the default options should just work
